/*
 * SPDX-FileCopyrightText: 2026 Nextcloud GmbH and Nextcloud contributors
 * SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick
import QtQuick.Layouts
import Style
import "../../tray"

Item {
    id: root

    required property var controller
    readonly property color primaryTextColor: Style.wizardPrimaryText
    readonly property color hintTextColor: Style.wizardSecondaryText

    ColumnLayout {
        anchors.fill: parent
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        anchors.topMargin: 28
        anchors.bottomMargin: 24
        spacing: 10

        // Brand logo
        Image {
            source: "qrc:/client/theme/colored/GeeksCloud-icon.svg"
            sourceSize.width: 72
            sourceSize.height: 72
            Layout.preferredWidth: 72
            Layout.preferredHeight: 72
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 4
            fillMode: Image.PreserveAspectFit
        }

        EnforcedPlainTextLabel {
            text: root.controller.publicShareSetup
                ? qsTr("Connect public share")
                : qsTr("Log in to %1").arg(root.controller.appName)
            color: root.primaryTextColor
            font.pixelSize: Style.pixelSize + 8
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        EnforcedPlainTextLabel {
            text: root.controller.publicShareSetup
                ? qsTr("Enter the share password if the link is password protected.")
                : qsTr("Enter the username and password for this server.")
            color: root.hintTextColor
            font.pixelSize: Style.pixelSize + 2
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        WizardTextField {
            Layout.fillWidth: true
            Layout.topMargin: 14
            text: root.controller.basicAuthUser
            enabled: !root.controller.busy
            placeholderText: qsTr("Username")
            selectByMouse: true
            onTextEdited: root.controller.basicAuthUser = text
            onAccepted: root.controller.submitBasicAuth()
        }

        WizardTextField {
            Layout.fillWidth: true
            text: root.controller.basicAuthPassword
            enabled: !root.controller.busy
            placeholderText: qsTr("Password")
            echoMode: TextInput.Password
            selectByMouse: true
            onTextEdited: root.controller.basicAuthPassword = text
            onAccepted: root.controller.submitBasicAuth()
        }

        EnforcedPlainTextLabel {
            visible: root.controller.errorText !== ""
            text: root.controller.errorText
            color: Style.wizardErrorText
            font.pixelSize: Style.pixelSize + 1
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        RowLayout {
            visible: root.controller.busy && root.controller.authStatusText !== ""
            Layout.alignment: Qt.AlignHCenter
            spacing: 8

            NCBusyIndicator {
                running: root.controller.busy
                visible: running
                Layout.preferredWidth: 20
                Layout.preferredHeight: 20
            }

            EnforcedPlainTextLabel {
                text: root.controller.authStatusText
                color: root.hintTextColor
                font.pixelSize: Style.pixelSize + 1
                wrapMode: Text.WordWrap
            }
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
