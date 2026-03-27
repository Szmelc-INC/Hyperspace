#!/bin/bash
# Start keyring daemon and set environment variables
eval $(/usr/bin/gnome-keyring-daemon --start --components=secrets,pkcs11,ssh)
# export $(dbus-launch)
