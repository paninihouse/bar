// batteryd — battery daemon for bar
//
// Uses IOKit to listen for power source changes (battery level, charging
// state, AC plug/unplug) and posts a Darwin notification.
//
// Compile:
//   cc -o bar-batteryd daemons/batteryd.c \
//       -framework IOKit -framework CoreFoundation

#include <IOKit/ps/IOPowerSources.h>
#include <IOKit/ps/IOPSKeys.h>
#include <notify.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static volatile int keep_running = 1;

static void handle_signal(int sig) {
	(void)sig;
	keep_running = 0;
}

static void power_source_changed(void *context) {
	(void)context;
	notify_post("bar.touch.<block-name>");
}

int main(void) {
	signal(SIGINT, handle_signal);
	signal(SIGTERM, handle_signal);

	CFRunLoopSourceRef source = IOPSNotificationCreateRunLoopSource(power_source_changed, NULL);
	if (source) {
		CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
		CFRelease(source);
	}

	while (keep_running) {
		pause();
	}

	return 0;
}
