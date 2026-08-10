# Hide & Show

Send a notification that hides or shows the bar.

Use the standard `notifyutil` program to post a Darwin notification that hides or shows the bar on-demand.

## Hide

```shell
notifyutil -p bar.hide
```

> Note: Hiding the bar won't stop blocks from being refreshed.

## Show

```shell
notifyutil -p bar.show
```
