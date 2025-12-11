import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    id: centerBar
    property string weatherText: "No weather data"

    Process {
        id: weatherProc
        command: ["sh", "-c", "python ~/Weather/weather.py"]

        stdout: SplitParser {
            onRead: dat => {
                centerBar.weatherText = dat;
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        onTriggered: weatherProc.running = true
    }
    anchors.centerIn: parent

    SystemClock {
        id: clock
    }

    Text {
        id: clockText
        text: Qt.formatDateTime(clock.date, "󰥔 HH.mm.ss - dd.MM.yyyy")
        color: root.colBg12
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
            bold: true
        }
    }

    Text {
        text: "|"
        color: root.colBg8
    }

    Text {
        id: weatherText
        text: centerBar.weatherText
        color: root.colBg12
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
            bold: true
        }
    }
}
