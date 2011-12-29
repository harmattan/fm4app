
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

import Qt 4.7
import com.nokia.meego 1.0

PageStackWindow {
    property bool fullsize: (platformWindow.viewMode == WindowState.Fullsize)

    // Unused boolean activity variables:
    //  - platformWindow.visible - Visible somewhere
    //  - platformWindow.active - Active (input focus?)

    initialPage: Page {
        orientationLock: PageOrientation.LockPortrait

        FM4App {
            anchors.fill: parent
        }
    }

    Component.onCompleted: {
        theme.inverted = true
    }
}

