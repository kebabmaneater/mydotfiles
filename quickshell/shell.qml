import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

PanelWindow {
    id: root

    property color colBg1: "#1E1E2E"
    property color colBg2: "#181825"
    property color colBg3: "#11111B"
    property color colBg4: "#313244"
    property color colBg5: "#45475A"
    property color colBg6: "#585B70"
    property color colBg7: "#6C7086"
    property color colBg8: "#7F849C"
    property color colBg9: "#9399B2"
    property color colBg10: "#A6ADC8"
    property color colBg11: "#BAC2DE"
    property color colBg12: "#CDD6F4"
    property color colFg1: "#F5E0DC"
    property color colFg2: "#F2CDCD"
    property color colFg3: "#F5C2E7"
    property color colFg4: "#CBA6F7"
    property color colFg5: "#F38BA8"
    property color colFg6: "#EBA0AC"
    property color colFg7: "#FAB387"
    property color colFg8: "#F9E2AF"
    property color colFg9: "#A6E3A1"
    property color colFg10: "#94E2D5"
    property color colFg11: "#89DCEB"
    property color colFg12: "#74C7EC"
    property color colFg13: "#89B4FA"
    property color colFg14: "#B4BEFE"

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

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 14

    LeftBar {}
    CenterBar {}
    RightBar {}
}
