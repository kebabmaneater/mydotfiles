import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }
    aboveWindows: false
    margins {
        right: 200
        left: 200
        top: 6
    }
    implicitHeight: 30
    color: root.colBg3

    LeftBar {}
    CenterBar {}
    RightBar {}
}
