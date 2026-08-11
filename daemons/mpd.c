// mpd — MPD (Music Player Daemon) daemon for bar
//
// Connects to MPD via TCP and uses the `idle` command to block until
// the player state or playlist changes. When it does, posts a Darwin
// notification. No polling, no special permissions — just a TCP socket.
//
// MPD_HOST and MPD_PORT environment variables are respected (same as
// mpc's convention). Defaults: localhost:6600.
//
// Compile:
//   cc -o bar-mpd daemons/mpd.c

#include <notify.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <netdb.h>
#include <sys/socket.h>
#include <errno.h>

static volatile int keep_running = 1;

static void handle_signal(int sig) {
	(void)sig;
	keep_running = 0;
}

// ── MPD helpers ──────────────────────────────────────────────────────

/// Read a line from the MPD socket (up to newline). Returns the number
/// of bytes read, or -1 on error. The line is null-terminated.
static int read_line(int fd, char *buf, size_t size) {
	size_t i = 0;
	while (i < size - 1) {
		ssize_t n = read(fd, &buf[i], 1);
		if (n <= 0) return -1;
		if (buf[i] == '\n') break;
		i++;
	}
	buf[i] = '\0';
	return (int)i;
}

/// Connect to MPD. Returns a socket fd, or -1 on failure.
static int connect_mpd(const char *host, int port) {
	struct addrinfo hints = {0}, *ai = NULL;
	hints.ai_family = AF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;

	char port_str[16];
	snprintf(port_str, sizeof(port_str), "%d", port);

	int err = getaddrinfo(host, port_str, &hints, &ai);
	if (err) return -1;

	int fd = -1;
	for (struct addrinfo *rp = ai; rp; rp = rp->ai_next) {
		fd = socket(rp->ai_family, rp->ai_socktype, rp->ai_protocol);
		if (fd < 0) continue;
		if (connect(fd, rp->ai_addr, rp->ai_addrlen) == 0) break;
		close(fd);
		fd = -1;
	}
	freeaddrinfo(ai);

	if (fd < 0) return -1;

	// Read the MPD greeting line (e.g. "OK MPD 0.23.0")
	char buf[256];
	if (read_line(fd, buf, sizeof(buf)) < 0) {
		close(fd);
		return -1;
	}

	return fd;
}

/// Send a command to MPD and read the response. Returns 0 on success.
static int mpd_command(int fd, const char *cmd) {
	char buf[1024];
	snprintf(buf, sizeof(buf), "%s\n", cmd);
	ssize_t len = strlen(buf);

	if (write(fd, buf, len) != len) return -1;

	// Read until we see "OK" or "ACK"
	while (1) {
		int n = read_line(fd, buf, sizeof(buf));
		if (n < 0) return -1;
		if (strcmp(buf, "OK") == 0) return 0;
		if (strncmp(buf, "ACK", 3) == 0) return -1;
		// ignore other response lines (e.g. "changed: player")
	}
}

// ── Main ─────────────────────────────────────────────────────────────

int main(void) {
	// Use sigaction so that read() is NOT restarted after a signal
	// (macOS's signal() enables SA_RESTART by default, which would
	//  cause the program to ignore Ctrl+C while blocked on read).
	struct sigaction sa = {0};
	sa.sa_handler = handle_signal;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;  // no SA_RESTART → read() returns EINTR
	sigaction(SIGINT, &sa, NULL);
	sigaction(SIGTERM, &sa, NULL);

	// Read MPD host/port from environment (same convention as mpc)
	const char *mpd_host = getenv("MPD_HOST");
	if (!mpd_host || !*mpd_host) mpd_host = "localhost";

	int mpd_port = 6600;
	const char *port_env = getenv("MPD_PORT");
	if (port_env && *port_env) mpd_port = atoi(port_env);

	while (keep_running) {
		int fd = connect_mpd(mpd_host, mpd_port);
		if (fd < 0) {
			// MPD not running yet — wait and retry
			for (int i = 0; i < 10 && keep_running; i++) sleep(1);
			continue;
		}

		// Enter idle mode — blocks until something changes
		while (keep_running) {
			const char *idle_cmd = "idle player playlist options\n";
			ssize_t len = strlen(idle_cmd);

			if (write(fd, idle_cmd, len) != len) break;

			// Read response — will block until MPD sends something
			char buf[256];
			int n = read_line(fd, buf, sizeof(buf));
			if (n < 0) break;

			// Drain the rest of the response
			while (1) {
				n = read_line(fd, buf, sizeof(buf));
				if (n < 0) break;
				if (strcmp(buf, "OK") == 0) break;
			}

			notify_post("bar.touch.<block-name>");
		}

		close(fd);

		// Brief pause before reconnecting
		if (keep_running) sleep(1);
	}

	return 0;
}
