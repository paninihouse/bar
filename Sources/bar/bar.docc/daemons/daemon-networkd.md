# networkd

React to network state changes.

This daemon listens for network configuration changes via **SystemConfiguration** and posts a Darwin notification that tells *bar* to refresh the desired block.
It fires when the WiFi connects or disconnects, the IP address changes, or a VPN toggles.

## How it works

The daemon uses `SCDynamicStore` to watch for changes to:
- `State:/Network/Global/IPv4` — IPv4 address changes.
- `State:/Network/Global/IPv6` — IPv6 address changes.
- `State:/Network/Interface/en0/AirPort` — WiFi state changes.

When any of these keys change, the daemon calls `notify_post("bar.touch.<block-name>")`.

The ``Notifier`` system in *bar* picks this up and re-runs the block's command.

### Dependencies

- SystemConfiguration.framework, CoreFoundation.framework

## Compile

```shell
cc -o bar-networkd daemons/networkd.c -framework SystemConfiguration -framework CoreFoundation
```

## Author

Tommaso Negri [@tommasongr](https://github.com/tommasongr)
