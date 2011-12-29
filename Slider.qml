
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

Item {
    id: slider
    property real value: knob.x/(bg.width - knob.width)

    width: bg.width
    height: bg.height

    Image {
        id: bg
        width: 141
        height: 20
        source: "artwork/volume_bg.png"
        smooth: true

        Image {
            id: fg
            width: knob.x
            height: bg.height
            fillMode: Image.Tile
            source: "artwork/volume_fg.png"
            smooth: true

            Image {
                id: knob
                x: .6 * (bg.width - knob.width)
                width: 20
                height: 20
                source: "artwork/volume_slider.png"
                smooth: true

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -16
                    drag.target: knob
                    drag.axis: Drag.XAxis
                    drag.minimumX: 0
                    drag.maximumX: bg.width - knob.width
                }
            }
        }
    }
}
