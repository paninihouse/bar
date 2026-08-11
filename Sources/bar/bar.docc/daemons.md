# Daemons

Extend the program with companion processes.

A *daemon* is a separate program that runs alongside *bar* and communicates with it via Darwin notifications (see ``Notifier``).
Unlike <doc:patches>, daemons do not modify *bar*'s source code, they are independent binaries that you compile and run on their own.

This approach keeps *bar* minimal and focused while still allowing it to react to system events like volume changes, network events, or battery status.
Daemons are written in C by default (though any language works), and each one is a single `.c` file that compiles with `cc`.

> Tip: Daemons are a good fit for events that require system-level APIs (CoreAudio, IOKit, CGEvent, etc.) without pulling that complexity into *bar* itself.

## How it works

A daemon listens for some system signal and, when it fires, posts a Darwin notification:

```c
notify_post("bar.touch.<block-name>");
```

The ``Notifier`` system in *bar* receives the notification and re-runs the corresponding block's command.
The block itself stays stateless, it just reads and prints the current state whenever it is called.

For example, the <doc:daemon-volumed> daemon listens for CoreAudio volume change events and posts `bar.touch.volume`.
The volume block in ``Config`` runs once per notification, prints the current volume, and the bar updates.

## How to install

Each daemon in the collection can be installed following the same pattern:

1. Edit the daemon file to send the correct notification/s:
```c
// Search in the file for a line like
notify_post("bar.touch.<block-name>");

// Replace it with the correct block name
notify_post("bar.touch.volume");

// If you want to update multiple blocks, just add
// another line below the first one
notify_post("bar.touch.volume");
notify_post("bar.touch.music");
```


2. Compile the daemon:
```shell
cc -o ~/.local/bin/<daemon-name> daemons/<daemon-name>.c -framework <dependency>
```

3. (Optional) Create a launch agent for automatic startup.
The process is very similar to the one described in the <doc:run-at-login> article.

## Topics

### Audio

- <doc:daemon-volumed>

### Display

- <doc:daemon-brightnessd>
- <doc:daemon-spaced>

### Power

- <doc:daemon-batteryd>

### Network

- <doc:daemon-networkd>

### Media

- <doc:daemon-nowplayingd>
- <doc:daemon-mpd>

### System

- <doc:daemon-devicesd>
- <doc:daemon-focusd>
