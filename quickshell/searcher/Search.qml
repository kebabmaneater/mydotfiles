import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

Scope {
    id: searcher
    property bool isSearchVisible: false

    GlobalShortcut {
        id: stuff
        description: "search for quickshell"
        name: "search"
        appid: "quickshell"
        onReleased: {
            searcher.isSearchVisible = !searcher.isSearchVisible;
        }
    }

    LazyLoader {
        active: searcher.isSearchVisible

        PanelWindow {
            color: root.colBg3
            exclusiveZone: 0
            focusable: true
            width: columnLayout.implicitWidth
            height: columnLayout.implicitHeight

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                right: 700
                left: 700
                top: 2
            }

            ColumnLayout {
                id: columnLayout
                width: parent.width
                anchors.margins: 10

                Item {
                    implicitHeight: 3
                }

                RowLayout {
                    Layout.fillWidth: true
                    Item {
                        width: 3
                    }
                    Text {
                        text: " "
                        font.family: root.fontFamily
                        font.pixelSize: root.fontSize
                        font.bold: true
                        color: root.colBg12
                    }
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        implicitHeight: 30
                        selectByMouse: true
                        placeholderText: "Search"
                        font.family: root.fontFamily
                        font.pixelSize: root.fontSize
                        font.bold: true
                        color: root.colBg12
                        background: Rectangle {
                            color: root.colBg1
                        }
                        focus: true
                        enabled: true
                        readOnly: false
                        onTextChanged: {
                            listModel.clear();
                            let query = searchField.text.toLowerCase();
                            for (let entry of DesktopEntries.applications.values) {
                                let fields = [entry.name || "", entry.genericName || "", entry.comment || "", (entry.keywords || []).join(" "), entry.id || ""];
                                let combined = fields.join(" ").toLowerCase();
                                if (query.length === 0 || combined.includes(query)) {
                                    listModel.append({
                                        "model": {
                                            "name": entry.name || "",
                                            "command": entry.command,
                                            "workingDirectory": entry.workingDirectory,
                                            "genericName": entry.genericName || "No generic name",
                                            "comment": entry.comment || "No entry",
                                            "keywords": (entry.keywords || []).join(" "),
                                            "id": entry.id || ""
                                        }
                                    });
                                }
                            }
                        }

                        onAccepted: {
                            let desktopEntry = listModel.get(0).model;
                            Quickshell.execDetached({
                                command: desktopEntry.command,
                                workingDirectory: desktopEntry.workingDirectory
                            });

                            searcher.isSearchVisible = false;
                        }
                    }
                    Item {
                        width: 3
                    }
                }

                Process {
                    id: searchProcess
                    property string output: ""
                    command: []
                    stdout: SplitParser {
                        onRead: data => {
                            listModel.clear();
                            for (let entry of data.split("\n")) {
                                if (entry.trim().length === 0)
                                    continue;
                                // Parse tab-separated fields
                                let fields = entry.split("\t");
                                listModel.append({
                                    "model": {
                                        "name": fields[0],
                                        "genericName": fields[1],
                                        "comment": fields[2],
                                        "keywords": fields[3],
                                        "id": fields[4]
                                    }
                                });
                            }
                            searchProcess.output = data.trim();
                        }
                    }

                    Component.onCompleted: {
                        listModel.clear();
                        let query = searchField.text.toLowerCase();
                        for (let entry of DesktopEntries.applications.values) {
                            let fields = [entry.name || "", entry.genericName || "", entry.comment || "", (entry.keywords || []).join(" "), entry.id || ""];
                            let combined = fields.join(" ").toLowerCase();
                            if (query.length === 0 || combined.includes(query)) {
                                listModel.append({
                                    "model": {
                                        "name": entry.name || "",
                                        "command": entry.command,
                                        "workingDirectory": entry.workingDirectory,
                                        "genericName": entry.genericName || "No generic name",
                                        "comment": entry.comment || "No entry",
                                        "keywords": (entry.keywords || []).join(" "),
                                        "id": entry.id || ""
                                    }
                                });
                            }
                        }
                    }
                }

                ListModel {
                    id: listModel
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 200
                    model: listModel
                    delegate: Row {
                        width: parent.width
                        height: 63
                        spacing: 5

                        RowLayout {
                            Layout.fillWidth: true
                            Item {
                                width: 3
                            }
                            Column {
                                spacing: 2
                                Text {
                                    color: root.colBg10
                                    text: model.name
                                    font.bold: true
                                }
                                Text {
                                    color: root.colBg8
                                    text: model.genericName
                                    font.pixelSize: root.fontSize - 2
                                }
                                Text {
                                    color: root.colBg7
                                    text: model.comment
                                    font.pixelSize: root.fontSize - 4
                                }
                            }
                            Item {
                                width: 3
                            }
                        }
                    }
                }
            }
        }
    }
}
