// nowplayingd — now playing daemon for bar
//
// Listens for track change notifications from Music.app and Spotify
// via DistributedNotificationCenter and posts a Darwin notification.
//
// Compile:
//   cc -o bar-nowplayingd daemons/nowplayingd.c -framework CoreFoundation

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

static void track_changed(
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

	// Music.app
	CFNotificationCenterAddObserver(
		center, NULL, track_changed,
		CFSTR("com.apple.Music.playerInfo"),
		NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	// Spotify
	CFNotificationCenterAddObserver(
		center, NULL, track_changed,
		CFSTR("com.spotify.client.PlaybackStateChanged"),
		NULL, CFNotificationSuspensionBehaviorDeliverImmediately);

	while (keep_running) {
		pause();
	}

	CFNotificationCenterRemoveEveryObserver(center, NULL);
	return 0;
}
