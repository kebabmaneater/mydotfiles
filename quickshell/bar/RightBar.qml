import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    id: rightBar
    anchors.fill: parent

    property int cpuUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property int netDownload: 0
    property int netUpload: 0
    property var lastRx: 0
    property var lastTx: 0
    property int memUsage: 0

    Item {
        Layout.fillWidth: true
    }

    Process {
        id: memProc
        command: ["sh", "-c", "free | grep Mem"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                rightBar.memUsage = Math.round(100 * used / total);
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: dat => {
                var p = dat.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                if (rightBar.lastCpuTotal > 0) {
                    rightBar.cpuUsage = Math.round(100 * (1 - (idle - rightBar.lastCpuIdle) / (total - rightBar.lastCpuTotal)));
                }
                rightBar.lastCpuTotal = total;
                rightBar.lastCpuIdle = idle;
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: netProc
        command: ["sh", "-c", "cat /proc/net/dev | grep eno1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var parts = data.trim().split(/\s+/);
                var rx = parseInt(parts[1]) || 0;
                var tx = parseInt(parts[9]) || 0;
                if (rightBar.lastRx > 0 && rightBar.lastTx > 0) {
                    var dl = (rx - rightBar.lastRx) / 2 * 8;
                    var ul = (tx - rightBar.lastTx) / 2 * 8;
                    rightBar.netDownload = dl;
                    rightBar.netUpload = ul;
                }
                rightBar.lastRx = rx;
                rightBar.lastTx = tx;
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: setVolumeProc
        property string volumeCmd: ""
        command: ["sh", "-c", volumeCmd]
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            pulseProc.running = true;
            netProc.running = true;
        }
    }

    Text {
        text: {
            function formatSpeed(bytes) {
                var kib = bytes / 1024;
                if (kib >= 1024)
                    return (kib / 1024).toFixed(1) + " MiB/s";
                else
                    return Math.round(kib) + " KiB/s";
            }
            return "󰛳 " + formatSpeed(rightBar.netDownload) + " ↓ " + formatSpeed(rightBar.netUpload) + " ↑";
        }
        color: root.colBg10
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
        text: " " + rightBar.memUsage + "%"
        color: root.colBg12
        font.pixelSize: root.fontSize
        font.family: root.fontFamily
        font.bold: true
    }

    Text {
        text: "|"
        color: root.colBg8
    }

    Text {
        text: " " + rightBar.cpuUsage + "%"
        color: root.colFg1
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
        text: " " + root.pulseVolume + "%"
        color: root.colBg11
        font {
            family: root.fontFamily
            pixelSize: root.fontSize
            bold: true
        }

        MouseArea {
            id: audioArea
            anchors.fill: parent
            onClicked: {
                root.mixerVisible = !root.mixerVisible;
            }
            onWheel: {
                // Adjust volume by 5% per wheel step
                var direction = wheel.angleDelta.y > 0 ? "+" : "-";
                var cmd = "pactl set-sink-volume @DEFAULT_SINK@ " + direction + "1%";
                setVolumeProc.volumeCmd = cmd;
                setVolumeProc.running = true;
                pulseProc.running = true;
            }
        }
    }

    Item {
        width: 5
    }
}
