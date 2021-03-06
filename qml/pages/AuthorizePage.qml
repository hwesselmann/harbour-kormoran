/*
    Kormoran
    Copyright (C) 2015 Hauke Wesselmann
    Contact: Hauke Wesselmann <hauke@h-dawg.de>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4
import "../models"

Dialog {
    id: authorizationPage

    property Python python

    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: true

    function authorizeKormoran() {
        if(pinTF.text.length > 0) {
            python.call('kormoran.retrieveAccessToken', [pinTF.text, StandardPaths.data], function(response) {});
        } else {
            infoBanner.showText(qsTr("Please enter your twitter PIN"));
        }
    }

    onAccepted: {
        authorizeKormoran()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + dlgheader.height

        Column
        {
            id: column
            anchors.top: parent.top
            width: parent.width
            spacing: 5

            DialogHeader
            {
                id: dlgheader
                acceptText: qsTr("Authorize")
            }

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                color: Theme.primaryColor
                wrapMode: Text.WordWrap
                text: qsTr("Sign into your twitter account and get the authorization code for Kormoran. \
The button below will the twitter sign in page in an external browser.")
            }

            Button {
                text: qsTr("Sign in")
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                onClicked: {
                    infoBanner.showText(qsTr("Opening twitter login in browser"));
                    python.call('kormoran.getAuthorizationUrl', [], function(url) {
                        Qt.openUrlExternally(url);
                    });
                }
            }

            Text {
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                wrapMode: Text.WordWrap
                color: Theme.primaryColor
                text: qsTr("After signing in, a PIN code will be displayed. Enter the PIN code in the text field and click 'authotize'.")
            }

            TextField {
                id: pinTF
                anchors {
                    left: parent.left
                    right: parent.right
                    margins: Theme.paddingLarge
                }
                inputMethodHints: Qt.ImhDigitsOnly
                placeholderText: qsTr("Enter twitter PIN")
                label: "twitter PIN"
                EnterKey.enabled: text.length > 0
                EnterKey.onClicked: authorizeKormoran()
            }
        }

        VerticalScrollDecorator {}
    }
}
