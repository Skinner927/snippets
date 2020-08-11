Sometimes XFCE is a dog and locks your ass out. I think this is an issue with
light-dm or something, but either way you can get into a state where you can't
log back into a running GUI session.

- `CTRL + ALT + F1` to switch to TTY1 (or another F-key for another TTY)
- Log in as the same user (or different, doesn't matter)
- `sudo -i loginctl list-sessions`
- `sudo -i loginctl unlock-session <id>`
  I'd suggest just trying all the IDs.
- `CTRL + ALT + F7` to switch back to the window manager session.
