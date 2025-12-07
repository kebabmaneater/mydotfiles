if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
    fastfetch --key-padding-left 2
end

# Aliases
function ls
    command ls --color=auto
end

function vim
    nvim
end

function rojo
    ~/.cargo/bin/rojo
end

function vlcw
    bash /mnt/sdb/Videot/vlcw.sh
end

function vlca
    bash /mnt/sdb/Videot/watch_all.sh
end

function yeet
    yay -Runs
end

function fml
    systemctl shutdown
end

function qmlls
    qmlls6 -E
end
