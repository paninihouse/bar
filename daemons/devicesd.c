// devicesd — USB device hotplug daemon for bar
//
// Uses IOKit to listen for USB device connect/disconnect events and
// posts a Darwin notification.
//
// Compile:
//   cc -o bar-devicesd daemons/devicesd.c \
//       -framework IOKit -framework CoreFoundation

#include <IOKit/IOKitLib.h>
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

static void device_event(void *refcon, io_iterator_t iterator) {
	(void)refcon;
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

	// Watch for USB devices
	CFMutableDictionaryRef matching = IOServiceMatching("IOUSBDevice");
	if (matching) {
		io_iterator_t iter;

		IOServiceAddMatchingNotification(
			notifyPort, kIOFirstMatchNotification, matching,
			device_event, NULL, &iter);
		device_event(NULL, iter); // drain initial set

		IOServiceAddMatchingNotification(
			notifyPort, kIOTerminatedNotification, matching,
			device_event, NULL, &iter);
	}

	// Also watch for Bluetooth devices
	CFMutableDictionaryRef btMatching = IOServiceMatching("IOBluetoothHCIController");
	if (btMatching) {
		io_iterator_t iter;
		IOServiceAddMatchingNotification(
			notifyPort, kIOFirstMatchNotification, btMatching,
			device_event, NULL, &iter);
		device_event(NULL, iter);
	}

	while (keep_running) {
		pause();
	}

	if (notifyPort) {
		IONotificationPortDestroy(notifyPort);
	}
	return 0;
}
