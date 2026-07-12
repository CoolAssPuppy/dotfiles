#!/bin/bash
# Opens Ghostty with the preferred layout:
# Left half: one tall pane | Right half: two stacked panes
#
# Layout:
# +----------+----------+
# |          |   top    |
# |   left   +----------+
# |          |  bottom  |
# +----------+----------+
#
# Usage: ~/.config/ghostty/ghostty-layout.sh
# Tip: assign this to a macOS keyboard shortcut or add to Login Items.

open -a Ghostty

# Wait for Ghostty to be ready
sleep 0.8

osascript -e '
tell application "System Events"
    tell process "Ghostty"
        set frontmost to true
        delay 0.3

        -- Split right (Cmd+D) to create left|right layout
        keystroke "d" using {command down}
        delay 0.5

        -- Now focus is in the right pane. Split down (Cmd+Shift+D).
        keystroke "d" using {command down, shift down}
        delay 0.3

        -- Move focus back to the left pane (Cmd+Opt+Left)
        key code 123 using {command down, option down}
    end tell
end tell
'
