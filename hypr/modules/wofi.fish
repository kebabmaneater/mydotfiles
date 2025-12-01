#!/usr/bin/env fish

# Define available options and their commands
set -l options "wofi --show drun -n" "bash ~/.config/waybar/power_menu.sh" "bash ~/.config/wofi/wofi-calc.sh" "bash ~/.config/wofi/video-searcher.sh"
set -l option_names drun power calc video_searcher

# Check for argument
if test (count $argv) -eq 0
    echo "Usage: (basename (status --current-filename)) [drun|power|calc|video_searcher]"
    exit 1
end

set -l arg $argv[1]
set -l idx -1

# Find the index of the argument
for i in (seq (count $option_names))
    if test $arg = $option_names[$i]
        set idx $i
        break
    end
end

if test $idx -eq -1
    echo "Invalid option: $arg"
    echo "Valid options: $option_names"
    exit 1
end

set -l menu $options[$idx]

# Check if any wofi instance is running and if it's the same option
set -l wofi_pid (pgrep -x wofi)
set -l current_option_file /tmp/wofi_current_option

if test -n "$wofi_pid"
    if test -f $current_option_file
        set -l running_option (cat $current_option_file)
        if test "$running_option" = "$arg"
            # Same option is running, just close it
            pkill -x wofi
            rm -f $current_option_file
            exit 0
        end
    end
    # Different option is running, close it first
    pkill -x wofi
end

# Record the current option
echo $arg >$current_option_file

# Launch the selected menu
eval $menu
