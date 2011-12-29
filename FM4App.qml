
/*
    Radio FM4 App for MeeGo Harmattan, Maemo 5 and Symbian
    Copyright (C) 2011  Thomas Perl <thp.io/about>
    http://thp.io/2011/fm4app/

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.0
import QtMultimediaKit 1.1

import 'fm4app.js' as FM4

Rectangle {
    id: root
    width: 360
    height: 640
    color: FM4.appBg

    property bool isFavoritesView: false

    onIsFavoritesViewChanged: {
        changeList.restart()
    }

    function loadTrackservice() {
        FM4.getTrackservice(receiveStuff)
    }

    function receiveStuff(html) {
        var l = html.split('<br>')
        var re = /^(\d{2}:\d{2}): <b>(.*)<\/b>[^<]*<i>(.*)<\/i>$/

        trackList.clear()
        for (var i=0; i<l.length; i++) {
            var x = l[i].trim()
            if (x.indexOf('|') != -1) {
                var result = re(x)
                if (result) {
                    trackList.insert(0, {
                        'time': result[1],
                        'track': result[2],
                        'artist': result[3],
                    })
                }
            }
        }
    }

    function withDb(somefunc) {
        var db = openDatabaseSync('FM4AppFavoritesDB', '1.0',
                                  'FM4 App DB', 1000)

        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS Favorite (artist TEXT, track TEXT)')
            somefunc(tx)
        })
    }

    function addFavorite(artist, track) {
        favorites.insert(0, {
            'artist': artist,
            'track': track,
        })
        writeFavorites()
    }

    function rmFavorite(artist, track) {
        for (var i=0; i<favorites.count; i++) {
            if (favorites.get(i).artist == artist &&
                favorites.get(i).track == track) {
                favorites.remove(i)
                break
            }
        }
        writeFavorites()
    }

    function isFavorite(artist, track) {
        for (var i=0; i<favorites.count; i++) {
            if (favorites.get(i).artist == artist &&
                favorites.get(i).track == track) {
                return true
            }
        }
        return false
    }

    function readFavorites() {
        root.withDb(function(tx) {
            favorites.clear()
            var rs = tx.executeSql('SELECT * FROM Favorite')
            for (var i=0; i<rs.rows.length; i++) {
                favorites.insert(0, {
                    'artist': rs.rows.item(i).artist,
                    'track': rs.rows.item(i).track,
                })
            }
        })
    }

    function writeFavorites() {
        root.withDb(function(tx) {
            tx.executeSql('DELETE FROM Favorite')
            for (var i=0; i<favorites.count; i++) {
                tx.executeSql('INSERT INTO Favorite VALUES (?, ?)', [
                    favorites.get(i).artist,
                    favorites.get(i).track
                ])
            }
        })
    }

    Component.onCompleted: {
        readFavorites()
        loadTrackservice()
    }

    ListModel {
        id: favorites
    }

    ListModel {
        id: trackList
    }

    Timer {
        repeat: true
        interval: 1000 * 60

        running: player.playing

        onTriggered: root.loadTrackservice()
    }

    Rectangle {
        color: FM4.pageBg
        anchors.fill: parent

        Item {
            id: trackserviceArea
            transform: Rotation {
                id: trackserviceRotation
                origin.x: trackservice.width / 2
                origin.y: trackservice.height / 2
                axis {
                    x: 0
                    y: 1
                    z: 0
                }
            }


            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                bottom: playerArea.top
            }

            Rectangle {
                id: logo
                z: 10

                gradient: Gradient {
                    GradientStop { position: 0; color: "#ffba00" }
                    GradientStop { position: 1; color: "#e39b00" }
                }

                Image {
                    anchors {
                        left: parent.left
                        top: parent.top
                    }
                    source: 'artwork/corner.png'
                }

                Image {
                    anchors {
                        right: parent.right
                        top: parent.top
                    }
                    source: 'artwork/corner.png'
                    rotation: 90
                }

                Image {
                    anchors {
                        left: parent.left
                        top: parent.top
                        margins: 15
                    }
                    opacity: mouseAreaAbout.pressed?.9:(isHarmattan?.7:.4)
                    source: 'artwork/symbian_about.png'

                    MouseArea {
                        id: mouseAreaAbout
                        anchors.fill: parent
                        onClicked: aboutBox.opacity = 1
                    }
                }

                Image {
                    anchors {
                        right: parent.right
                        top: parent.top
                        margins: 15
                    }
                    opacity: mouseAreaClose.pressed?.9:(isHarmattan?.7:.4)
                    source: 'artwork/symbian_close.png'
                    visible: !isHarmattan || isFremantle

                    MouseArea {
                        id: mouseAreaClose
                        anchors.fill: parent
                        onClicked: Qt.quit()
                    }
                }

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    right: parent.right
                }

                height: 150

                Text {
                    id: heading
                    anchors {
                        left: parent.left
                        bottom: parent.bottom
                        bottomMargin: 12
                        leftMargin: 20
                    }

                    color: 'black'
                    text: (trackservice.model==favorites)?'Favoriten':'Trackservice'
                    font.pixelSize: 20 * scaling
                }

                Image {
                    anchors {
                        right: parent.right
                        bottom: parent.bottom
                    }

                    source: 'artwork/topbar_small.png'
                }
            }

            Text {
                anchors.centerIn: trackservice
                visible: (trackservice.model.count == 0 && trackservice.model == favorites)
                text: 'Keine Favoriten.'
                font.pixelSize: 14 * scaling
                color: 'white'
            }

            ListView {
                id: trackservice

                SequentialAnimation {
                    id: changeList

                    ParallelAnimation {
                        PropertyAnimation {
                            target: trackserviceArea
                            property: 'scale'
                            to: .9
                        }

                        PropertyAnimation {
                            target: trackserviceArea
                            property: 'opacity'
                            to: 0
                        }
                    }

                    ScriptAction {
                        script: {
                            if (root.isFavoritesView) {
                                trackservice.model = favorites
                            } else {
                                trackservice.model = trackList
                            }
                        }
                    }

                    ParallelAnimation {
                        PropertyAnimation {
                            target: trackserviceArea
                            property: 'scale'
                            to: 1
                        }

                        PropertyAnimation {
                            target: trackserviceArea
                            property: 'opacity'
                            to: 1
                        }
                    }

                    /*PropertyAnimation {
                        target: trackservice
                        property: 'anchors.leftMargin'
                        to: 0
                    }*/
                }

                anchors {
                    top: logo.bottom
                    left: parent.left
                    bottom: parent.bottom
                }
                width: parent.width

                clip: true

                model: trackList //root.isFavoritesView?favorites:trackList

                delegate: Item {
                    height: 50 * scaling
                    width: parent.width

                    Row {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            right: star.left
                            leftMargin: 10
                        }
                        spacing: 10
                        clip: true

                        Text {
                            text: {
                                if (trackservice.model == trackList) {
                                    time + '\n'
                                } else {
                                    ''
                                }
                            }
                            font.pixelSize: 12 * scaling
                            font.bold: true
                            color: FM4.textFg
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Column {
                            spacing: 3

                            anchors.verticalCenter: parent.verticalCenter

                            Text {
                                color: FM4.textFg
                                text: track
                                font.pixelSize: 14 * scaling
                            }

                            Text {
                                color: FM4.yellow
                                font.bold: true
                                text: artist
                                font.pixelSize: 12 * scaling
                            }
                        }
                    }

                    Item {
                        id: star
                        property bool favorite: false

                        Component.onCompleted: {
                            favorite = isFavorite(artist, track)
                        }

                        anchors {
                            top: parent.top
                            bottom: parent.bottom
                            right: parent.right
                        }

                        width: height

                        Image {
                            anchors.centerIn: parent
                            source: star.favorite?'artwork/star_high.png':'artwork/star_low.png'
                            scale: .6
                            smooth: true
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if (star.favorite) {
                                    rmFavorite(artist, track)
                                } else {
                                    addFavorite(artist, track)
                                }

                                star.favorite = !star.favorite
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: playerArea

            Audio {
                id: player
                volume: slider.value
            }

            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: 100

            Row {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    bottomMargin: 26
                }
                scale: isHarmattan?1:.83

                spacing: 16

                Image {
                    anchors.verticalCenter: parent.verticalCenter

                    source: {
                        if (player.playing) {
                            'artwork/button_stop.png'
                        } else {
                            'artwork/button_play.png'
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            if (player.playing) {
                                player.source = ''
                            } else {
                                player.source = FM4.streamUrl
                            }

                            player.playing = !player.playing
                        }
                    }
                }

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: 'artwork/volume_min.png'
                }

                Slider {
                    anchors.verticalCenter: parent.verticalCenter
                    id: slider
                }

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: 'artwork/volume_max.png'
                }

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: root.isFavoritesView?'artwork/button_tracks.png':'artwork/button_star.png'

                    MouseArea {
                        anchors.fill: parent
                        onClicked: root.isFavoritesView = !root.isFavoritesView
                    }
                }
            }

            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
                    margins: 3
                }

                color: FM4.lineFg
                font.pixelSize: 10 * scaling
                text: {
                    switch (player.status) {
                        case Audio.NoMedia: ''
                        case Audio.Loading: "Bitte warten..."
                        case Audio.Loaded: "Bereit"
                        case Audio.Buffering: "Zwischenspeichern..."
                        case Audio.Stalled: "Einen Moment bitte..."
                        case Audio.Buffered: "Live-Stream"
                        case Audio.EndOfMedia: "Stream-Ende erreicht"
                        case Audio.InvalidMedia: ''
                        default: "Unbekannter Fehler"
                    }

                }
            }
        }
    }

    Rectangle {
        id: aboutBox
        anchors.fill: parent
        color: '#dd000000'

        opacity: 0
        Behavior on opacity { PropertyAnimation { } }

        Column {
            anchors.centerIn: parent
            spacing: 5
            scale: Math.pow(parent.opacity, 3)

            Item {
                height: aboutBoxIcon.sourceSize.height
                width: parent.width

                Image {
                    id: aboutBoxIcon
                    anchors.centerIn: parent
                    source: 'fm4app.png'
                }
            }

            Text {
                color: 'white'
                font.pixelSize: isHarmattan?30:25
                font.bold: true
                text: 'Radio FM4 App 1.2.0'
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: 'white'
                text: 'http://thp.io/2011/fm4app/'
                font.pixelSize: isHarmattan?25:20
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                color: 'white'
                font.pixelSize: isHarmattan?20:15
                text: '\nAuthor: Thomas Perl\nBuild: 2011-12-29 '+(isHarmattan?(isFremantle?'Fremantle':'Harmattan'):'Symbian')+'\n\nYou need a WIFI connection or a (preferably unlimited) data plan to use the streaming and trackservice features. The author is not liable for data traffic costs caused by using this application.\n\nReleased under the GNU GPLv3'
                wrapMode: Text.WordWrap
                width: root.width * .7
                horizontalAlignment: Text.AlignHCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (parent.opacity > 0) {
                    parent.opacity = 0
                } else {
                    parent.opacity = 1
                }
            }
        }
    }
}

