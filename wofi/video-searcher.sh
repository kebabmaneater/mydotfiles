#!/usr/bin/env bash

VIDEO_DIR="/mnt/sdb/Videot"
EXT="mkv"
TITLE_FILE="$VIDEO_DIR/known_titles.txt"

declare -A title_map

while IFS= read -r line; do
        # Convert "TITLE - S00E00" to "TITLE.S00E00.$EXT"
        file_name="${line// - /.}.$EXT"
        title_map["$line"]="$file_name"
done <"$TITLE_FILE"

choices=$(printf "%s\n" "${!title_map[@]}")
CHOICE=$(wofi --show dmenu -n --sort-order=default --cache-file=/dev/null -d -p video <<<"$choices")
rtrn=$?

if test "$rtrn" = "0"; then
        if [[ -n "$CHOICE" ]]; then
                mpv "$VIDEO_DIR/${title_map[$CHOICE]}"
                exit 0
        fi
fi
