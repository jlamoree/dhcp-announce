# Pushcut Announce

## Description
It can be helpful to know when a Raspberry Pi is booted and on a network -- especially if the IP tends to change for reasons.
This project adds a systemd unit that announces the IP(s) issued after the network is brought up at boot using [Pushcut](https://www.pushcut.io).

## Installation
Run `sudo ./install.sh`
The installation script is very chatty about what it does. If an existing configuration file exists, it will ask whether or not it should be replaced.

## Configuration
The configuration file is extremely complicated. It contains the following variable:
```
pushcut_url="https://api.pushcut.io/example_webhook_secret/notifications/I%20Like%20Pi"
```
Edit the file at `/usr/local/etc/pushcut-announce` to provide the Pushcut Webhook URL for the Notification.

## Troubleshooting
If you are not receiving the expected notification on the iOS/iPadOS devices with Pushcut installed, try running the script manually. The response from the script/service should offer some guidance. Here are some examples:
```
pi@raspberrypi:~ $ sudo /usr/local/bin/pushcut-announce
Webhook call unsuccessful. {"error":"Invalid secret."}

pi@raspberrypi:~ $ sudo /usr/local/bin/pushcut-announce
Webhook call unsuccessful. {"error":"Notification not found."}

pi@raspberrypi:~ $ sudo /usr/local/bin/pushcut-announce
Webhook call unsuccessful. curl: (6) Could not resolve host: api.pushcut.io
```
If the output from `/usr/local/bin/pushcut-announce` is successful, but notifications are not being sent on boot, check systemd for status:
```
pi@raspberrypi:~ $ sudo systemctl status pushcut-announce.service
```

## Issues
Please report issues using https://github.com/jlamoree/pushcut-announce/issues

## License
This project is licensed under the terms of the MIT license. See LICENSE.
