// volumed — volume daemon for bar
//
// Uses CoreAudio to listen for system volume/mute changes instead of
// a CGEvent tap, so no Accessibility permission is required.
//
// When the volume changes, it posts a Darwin notification that tells
// bar to refresh the "volume" block.
//
// Compile:
//   cc -o bar-volumed daemons/volumed.c -framework CoreAudio

#include <CoreAudio/CoreAudio.h>
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

// ── Volume change callback ───────────────────────────────────────────

static OSStatus volume_changed(
	AudioObjectID object,
	UInt32 num_addresses,
	const AudioObjectPropertyAddress addresses[],
	void *context
) {
	(void)object; (void)num_addresses; (void)addresses; (void)context;
	notify_post("bar.touch.<block-name>");
	return noErr;
}

// ── Device change callback ───────────────────────────────────────────
// Re-registers the volume listener when the output device changes
// (e.g. headphones plugged in).

static AudioDeviceID current_device = kAudioObjectUnknown;
static void register_volume_listener(AudioDeviceID device);

static OSStatus device_changed(
	AudioObjectID object,
	UInt32 num_addresses,
	const AudioObjectPropertyAddress addresses[],
	void *context
) {
	(void)object; (void)num_addresses; (void)addresses; (void)context;

	AudioObjectPropertyAddress addr = {
		kAudioHardwarePropertyDefaultOutputDevice,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMain
	};
	AudioDeviceID new_device = kAudioObjectUnknown;
	UInt32 size = sizeof(new_device);
	AudioObjectGetPropertyData(
		kAudioObjectSystemObject, &addr, 0, NULL, &size, &new_device);

	if (new_device != current_device && new_device != kAudioObjectUnknown) {
		register_volume_listener(new_device);
	}
	return noErr;
}

// ── Register listener on a device ────────────────────────────────────

static void register_volume_listener(AudioDeviceID device) {
	// Remove old listener if any
	if (current_device != kAudioObjectUnknown) {
		AudioObjectPropertyAddress old_addr = {
			kAudioDevicePropertyVolumeScalar,
			kAudioDevicePropertyScopeOutput,
			1  // channel 1
		};
		AudioObjectRemovePropertyListener(
			current_device, &old_addr, volume_changed, NULL);
	}

	current_device = device;

	// Get the preferred stereo channel (usually 1)
	UInt32 channel = 1;
	AudioObjectPropertyAddress chan = {
		kAudioDevicePropertyPreferredChannelsForStereo,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMain
	};
	UInt32 channels[2] = {0, 0};
	UInt32 size = sizeof(channels);
	if (AudioObjectGetPropertyData(device, &chan, 0, NULL, &size, &channels) == noErr) {
		channel = channels[0];
	}

	// Listen for volume changes on the main output channel
	AudioObjectPropertyAddress vol_addr = {
		kAudioDevicePropertyVolumeScalar,
		kAudioDevicePropertyScopeOutput,
		channel
	};
	AudioObjectAddPropertyListener(device, &vol_addr, volume_changed, NULL);

	// Also listen for mute changes
	AudioObjectPropertyAddress mute_addr = {
		kAudioDevicePropertyMute,
		kAudioDevicePropertyScopeOutput,
		kAudioObjectPropertyElementMain
	};
	AudioObjectAddPropertyListener(device, &mute_addr, volume_changed, NULL);
}

// ── Main ─────────────────────────────────────────────────────────────

int main(void) {
	signal(SIGINT, handle_signal);
	signal(SIGTERM, handle_signal);

	// Listen for output device changes
	AudioObjectPropertyAddress dev_addr = {
		kAudioHardwarePropertyDefaultOutputDevice,
		kAudioObjectPropertyScopeGlobal,
		kAudioObjectPropertyElementMain
	};
	AudioObjectAddPropertyListener(
		kAudioObjectSystemObject, &dev_addr, device_changed, NULL);

	// Register on the current device
	UInt32 size = sizeof(current_device);
	AudioObjectGetPropertyData(
		kAudioObjectSystemObject, &dev_addr, 0, NULL, &size, &current_device);

	if (current_device != kAudioObjectUnknown) {
		register_volume_listener(current_device);
	}

	// Run until SIGINT/SIGTERM
	while (keep_running) {
		pause();
	}

	// Cleanup
	if (current_device != kAudioObjectUnknown) {
		AudioObjectPropertyAddress vol_addr = {
			kAudioDevicePropertyVolumeScalar,
			kAudioDevicePropertyScopeOutput,
			1  // channel 1
		};
		AudioObjectRemovePropertyListener(
			current_device, &vol_addr, volume_changed, NULL);
	}

	return 0;
}
