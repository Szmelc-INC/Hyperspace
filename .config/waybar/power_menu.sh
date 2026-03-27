#!/bin/bash
choice=$(printf " Shutdown\n Reboot\n Sleep\n Logout" | rofi -dmenu -p "Power Menu")

case "$choice" in
  " Shutdown") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  " Sleep") systemctl suspend ;;
  " Logout") hyprctl dispatch exit ;;
esac
