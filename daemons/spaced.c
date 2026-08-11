// spaced — desktop space daemon for bar
//
// Monitors the active desktop space and posts a Darwin notification
// when the space changes. Uses a lightweight 0.5s poll of a CoreGraphics
// private API.
//
// Compile:
//   cc -o bar-spaced daemons/spaced.c -framework CoreFoundation

#include <CoreFoundation/CoreFoundation.h>
#include <dlfcn.h>
#include <notify.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static volatile int keep_running = 1;

// Private CoreGraphics API
typedef CFStringRef (*CGSCopyActiveMenuBarDisplayIdentifierFunc)(void);

static CGSCopyActiveMenuBarDisplayIdentifierFunc copyIdentifier = NULL;

static void handle_signal(int sig) {
	(void)sig;
	keep_running = 0;
}

int main(void) {
	signal(SIGINT, handle_signal);
	signal(SIGTERM, handle_signal);

	// Load the private CGS API at runtime
	void *handle = dlopen(
		"/System/Library/PrivateFrameworks/CoreGraphics.framework/CoreGraphics",
		RTLD_LAZY | RTLD_LOCAL);

	if (!handle) {
		fprintf(stderr, "bar-spaced: could not load CoreGraphics framework\n");
		return 1;
	}

	copyIdentifier = (CGSCopyActiveMenuBarDisplayIdentifierFunc)
		dlsym(handle, "CGSCopyActiveMenuBarDisplayIdentifier");

	if (!copyIdentifier) {
		fprintf(stderr, "bar-spaced: could not find CGS API\n");
		dlclose(handle);
		return 1;
	}

	CFStringRef last = NULL;
	unsigned int pollCount = 0;

	while (keep_running) {
		CFStringRef current = copyIdentifier();

		if (current) {
			if (!last || !CFEqual(current, last)) {
				notify_post("bar.touch.<block-name>");
				if (last) CFRelease(last);
				last = CFStringCreateCopy(NULL, current);
			}
			CFRelease(current);
		}

		usleep(500000); // 0.5 second intervals
		pollCount++;
	}

	if (last) CFRelease(last);
	dlclose(handle);
	return 0;
}
