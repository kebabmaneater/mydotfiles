import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire

Scope {
    LazyLoader {
        active: root.mixerVisible

        PanelWindow {
            color: root.colBg3
            exclusiveZone: 0
            width: columnLayout.implicitWidth
            height: columnLayout.implicitHeight

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                right: 200
                left: 1300
                top: 2
            }

            ColumnLayout {
                id: columnLayout
                anchors.margins: 10
                Item {
                    implicitHeight: 5
                    Layout.fillWidth: true
                }

                anchors {
                    right: parent.right
                }

                PwNodeLinkTracker {
                    id: linkTracker
                    node: Pipewire.defaultAudioSink
                }

                MixerEntry {
                    node: Pipewire.defaultAudioSink
                }

                Repeater {
                    model: linkTracker.linkGroups

                    MixerEntry {
                        required property PwLinkGroup modelData
                        // Each link group contains a source and a target.
                        // Since the target is the default sink, we want the source.
                        node: modelData.source
                    }
                }

                Item {
                    implicitHeight: 5
                    Layout.fillWidth: true
                }
            }
        }
    }
}
