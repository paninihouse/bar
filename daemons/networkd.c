// bar-networkd — network status daemon for bar
//
// Uses SystemConfiguration to listen for network state changes
// (WiFi connect/disconnect, IP address changes, VPN toggle) and
// posts a Darwin notification.
//
// Compile:
//   cc -o bar-networkd daemons/networkd.c \
//       -framework SystemConfiguration -framework CoreFoundation

#include <SystemConfiguration/SystemConfiguration.h>
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

static void network_changed(
	SCDynamicStoreRef store, CFArrayRef changedKeys, void *info
) {
	(void)store; (void)changedKeys; (void)info;
	notify_post("bar.touch.<block-name>");
}

int main(void) {
	signal(SIGINT, handle_signal);
	signal(SIGTERM, handle_signal);

	SCDynamicStoreContext context = {0, NULL, NULL, NULL, NULL};
	SCDynamicStoreRef store = SCDynamicStoreCreate(
		NULL, CFSTR("bar-networkd"), network_changed, &context);

	if (!store) {
		fprintf(stderr, "bar-networkd: could not create dynamic store\n");
		return 1;
	}

	// Watch for IPv4, IPv6, and WiFi state changes
	const void *keys[] = {
		CFSTR("State:/Network/Global/IPv4"),
		CFSTR("State:/Network/Global/IPv6"),
		CFSTR("State:/Network/Interface/en0/AirPort"),
		CFSTR("State:/Network/Interface/en1/AirPort"),
	};
	CFArrayRef keyArray = CFArrayCreate(
		NULL, keys, 4, &kCFTypeArrayCallBacks);
	SCDynamicStoreSetNotificationKeys(store, keyArray, NULL);
	CFRelease(keyArray);

	CFRunLoopSourceRef source = SCDynamicStoreCreateRunLoopSource(NULL, store, 0);
	CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
	CFRelease(source);

	while (keep_running) {
		pause();
	}

	CFRelease(store);
	return 0;
}
