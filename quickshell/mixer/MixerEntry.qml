import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

ColumnLayout {
    required property PwNode node

    // bind the node so we can read its properties
    PwObjectTracker {
        objects: [node]
    }

    RowLayout {
        Item {
            Layout.fillWidth: true
        }

        Label {
            text: {
                // application.name -> description -> name
                const app = node.properties["application.name"] ?? (node.description != "" ? node.description : node.name);
                let media = node.properties["media.name"];
                if (media !== undefined && media.length > 32) {
                    media = media.substring(0, 32);
                    media = media.trim(media);
                    media += "...";
                }
                return media != undefined ? `${app} - ${media}` : app;
            }
            color: root.colBg12
        }

        Image {
            visible: source != ""
            source: {
                const isMuted = node.audio.muted;
                const icon = isMuted ? "audio-volume-muted-symbolic" : "audio-volume-high-symbolic";
                return `image://icon/${icon}`;
            }

            sourceSize.width: 20
            sourceSize.height: 20

            MouseArea {
                anchors.fill: parent
                onClicked: node.audio.muted = !node.audio.muted
                cursorShape: Qt.PointingHandCursor
            }
        }
    }

    RowLayout {
        Item {
            Layout.fillWidth: true
        }
        Slider {
            id: control
            value: node.audio.volume
            implicitWidth: 340
            onValueChanged: {
                node.audio.volume = value;
                pulseProc.running = true;
            }

            background: Rectangle {
                x: control.leftPadding
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 4
                width: control.availableWidth
                height: implicitHeight
                radius: 2
                color: root.colBg5

                Rectangle {
                    width: control.visualPosition * parent.width
                    height: parent.height
                    color: root.colBg12
                    radius: 2
                }
            }

            handle: Rectangle {
                x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
                y: control.topPadding + control.availableHeight / 2 - height / 2
                implicitWidth: 13
                implicitHeight: 13
                color: control.pressed ? root.colBg9 : root.colBg10
            }
        }
        Label {
            Layout.preferredWidth: 50
            text: `${Math.floor(node.audio.volume * 100)}%`
            color: root.colBg12
        }
    }
}
