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

    Text {
        id: clockText
        text: formatClock()
        color: root.colBg12
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
            bold: true
        }
        function formatClock() {
            var d = new Date();
            var pad = function (n) {
                return n < 10 ? "0" + n : n;
            };
            return "󰥔 " + pad(d.getHours()) + "." + pad(d.getMinutes()) + "." + pad(d.getSeconds()) + " - " + pad(d.getDate()) + "." + (d.getMonth() + 1) + "." + d.getFullYear();
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text = formatClock()
            function formatClock() {
                var d = new Date();
                var pad = function (n) {
                    return n < 10 ? "0" + n : n;
                };
                return "󰥔 " + pad(d.getHours()) + "." + pad(d.getMinutes()) + "." + pad(d.getSeconds()) + " - " + pad(d.getDate()) + "." + (d.getMonth() + 1) + "." + d.getFullYear();
            }
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
