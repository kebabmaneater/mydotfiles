import Quickshell
import QtQuick
import "../mixer"
import "../power"

PanelWindow {
    id: bar
    property bool mixerVisible: false
    property bool powerVisible: false
    property int pulseVolume: 0

    anchors {
        top: true
        left: true
        right: true
    }
    aboveWindows: true
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

    Mixer {}
    PowerMenu {}
}
