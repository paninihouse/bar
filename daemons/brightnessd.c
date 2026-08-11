// brightnessd — display brightness daemon for bar
//
// Uses IOKit to listen for display brightness changes and posts
// a Darwin notification.
//
// Compile:
//   cc -o bar-brightnessd daemons/brightnessd.c \
//       -framework IOKit -framework CoreFoundation

#include <IOKit/IOKitLib.h>
#include <IOKit/graphics/IOGraphicsLib.h>
#include <notify.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

static volatile int keep_running = 1;
static IONotificationPortRef notifyPort = NULL;

static void handle_signal(int sig) {
	(void)sig;
	keep_running = 0;
}

static void brightness_changed(void *refcon, io_iterator_t iterator) {
	(void)refcon;
	// Drain the iterator
	io_object_t obj;
	while ((obj = IOIteratorNext(iterator))) {
		IOObjectRelease(obj);
	}
	notify_post("bar.touch.<block-name>");
}

int main(void) {
	signal(SIGINT, handle_signal);
	signal(SIGTERM, handle_signal);

	notifyPort = IONotificationPortCreate(kIOMasterPortDefault);
	CFRunLoopSourceRef source = IONotificationPortGetRunLoopSource(notifyPort);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);

	// Watch for brightness-related display changes
	CFMutableDictionaryRef matching = IOServiceMatching("AppleBacklightDisplay");
	if (!matching) {
		// Fallback: try Intel backlight
		matching = IOServiceMatching("AppleIntelPanel");
	}
	if (!matching) {
		matching = IOServiceMatching("IODisplay");
	}

	if (matching) {
		io_iterator_t iter;
		IOServiceAddMatchingNotification(
			notifyPort, kIOFirstMatchNotification, matching,
			brightness_changed, NULL, &iter);
		brightness_changed(NULL, iter); // drain initial

		// Also watch for termination to catch display disconnect
		IOServiceAddMatchingNotification(
			notifyPort, kIOTerminatedNotification, matching,
			brightness_changed, NULL, &iter);
	}

	while (keep_running) {
		pause();
	}

	if (notifyPort) {
		IONotificationPortDestroy(notifyPort);
	}
	return 0;
}
