import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import Quickshell.Io

Scope {
    Process {
        id: powerMenuProc
        property string powerMenuCmd: ""
        command: ["sh", "-c", powerMenuCmd]
    }

    GlobalShortcut {
        id: stuff
        description: "power"
        name: "power"
        appid: "quickshell"
        onReleased: {
            bar.powerVisible = !bar.powerVisible;
        }
    }

    LazyLoader {
        active: bar.powerVisible

        PanelWindow {
            color: root.colBg3
            implicitWidth: 200
            implicitHeight: 130
            exclusiveZone: 0

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                right: 1450
                left: 200
                top: 2
            }

            ScrollView {
                anchors.fill: parent
                contentWidth: availableWidth

                ColumnLayout {
                    anchors.fill: parent

                    Item {
                        height: 3
                    }

                    Repeater {
                        model: 5

                        Text {
                            text: " " + [" Suspend", " Reboot", " Power Off", " Lock", "󰍃 Logout"][index]
                            color: root.colBg10
                            font {
                                family: root.fontFamily
                                pixelSize: root.fontSize
                                bold: true
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    bar.powerVisible = false;
                                    powerMenuProc.powerMenuCmd = ["systemctl suspend", "systemctl reboot", "systemctl poweroff", "loginctl lock-session", "hyprctl dispatch exit"][index];
                                    powerMenuProc.running = true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
