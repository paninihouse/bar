// bar-focusd — Focus / Do Not Disturb daemon for bar
//
// Listens for Focus mode and DND changes via DistributedNotificationCenter
// and posts a Darwin notification.
//
// Compile:
//   cc -o bar-focusd daemons/focusd.c -framework CoreFoundation

#include <CoreFoundation/CoreFoundation.h>
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

static void focus_changed(
	CFNotificationCenterRef center, void *observer,
	CFStringRef name, const void *object, CFDictionaryRef userInfo
) {
	(void)center; (void)observer; (void)name; (void)object; (void)userInfo;
	notify_post("bar.touch.<block-name>");
}

int main(void) {
	signal(SIGINT, handle_signal);
	signal(SIGTERM, handle_signal);

	CFNotificationCenterRef center = CFNotificationCenterGetDistributedCenter();

	// DND / Focus mode changes
	CFNotificationCenterAddObserver(
		center, NULL, focus_changed,
		CFSTR("com.apple.notificationcenter.dndprefs_changed"),
		NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	while (keep_running) {
		pause();
	}

	CFNotificationCenterRemoveEveryObserver(center, NULL);
	return 0;
}
