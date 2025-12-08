import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    id: leftBar
    anchors.fill: parent
    property string activeWindow: "Window"

    Process {
        id: windowProc
        command: ["sh", "-c", "hyprctl activewindow -j | jq -r '{class, title} | @base64'"]
        stdout: SplitParser {
            onRead: data => {
                // Decode base64 and parse JSON
                function decodeBase64(str) {
                    try {
                        return JSON.parse(Qt.atob(str));
                    } catch (e) {
                        return {
                            class: "",
                            title: ""
                        };
                    }
                }
                const regexMap = [
                    {
                        pattern: /( — Firefox| - Mozilla Firefox|Firefox|Firefox Nightly|zen)$/i,
                        value: " Zen"
                    },
                    {
                        pattern: /(kitty)$/i,
                        value: " Kitty"
                    },
                    {
                        pattern: /.*/,
                        value: " Empty"
                    },
                    {
                        pattern: /(Steam|steam)$/i,
                        value: " Steam"
                    }
                ];
                let display = "broken";
                if (data && data.trim()) {
                    const win = decodeBase64(data);
                    for (let i = 0; i < regexMap.length; i++) {
                        if (regexMap[i].pattern.test(win.class)) {
                            display = regexMap[i].value + " — " + win.title;
                            break;
                        }
                    }

                    if (display === regexMap[2].value + " — null") {
                        display = regexMap[2].value;
                    }

                    if (display !== regexMap[2].value + " — null") {
                        if (display === regexMap[2].value + " — " + win.title) {
                            display = win.title;
                        }
                    }

                    if (display.length > 45) {
                        display = display.substring(0, 42);
                        display = display.trim(display);
                        display += "...";
                    }
                }
                leftBar.activeWindow = display;
            }
        }
        Component.onCompleted: running = true
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            windowProc.running = true;
        }
    }

    Timer {
        interval: 10000
        onTriggered: {
            windowProc.running = true;
        }
    }

    Item {
        width: 5
    }

    Text {
        text: "󰣇"
        font.pixelSize: root.fontSize
        font.family: root.fontFamily
        color: root.colBg12
        font.bold: true
        MouseArea {
            id: powerArea
            anchors.fill: parent
            onClicked: {
                root.powerVisible = !root.powerVisible;
            }
        }
    }

    Text {
        text: "|"
        color: root.colBg8
    }

    Repeater {
        model: 10

        Text {
            property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            text: index + 1
            color: isActive ? root.colBg12 : (ws ? root.colBg7 : root.colBg4)
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }

            Rectangle {
                width: 16
                height: 2
                color: parent.isActive ? root.colFg14 : root.colBg3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }

    Text {
        text: leftBar.activeWindow
        color: root.colFg1
        font.pixelSize: root.fontSize
        font.family: root.fontFamily
        font.bold: true
        Layout.fillWidth: true
        Layout.leftMargin: 8
        elide: Text.ElideRight
        maximumLineCount: 1
    }

    Item {
        width: 5
    }
}
