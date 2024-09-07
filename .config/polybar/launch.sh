#!/usr/bin/env fish

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

switch (hostname)
    case "frankie"
        polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
    case "*"
        polybar mobile 2>&1 | tee -a /tmp/polybar1.log & disown
end

echo "Bars launched..."
