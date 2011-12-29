
# Radio FM4 App for MeeGo Harmattan, Maemo 5 and Symbian
# Copyright (C) 2011  Thomas Perl <thp.io/about>
# http://thp.io/2011/fm4app/
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

QT += declarative

TEMPLATE = app
DEPENDPATH += .
INCLUDEPATH += .

SOURCES += main.cc

RESOURCES += fm4app.qrc

QMAKE_RESOURCE_FLAGS += -threshold 0 -compress 9

linux-g++-maemo {
    DEFINES += "Q_OS_MAEMO"

    INSTALLS += target desktop icon

    target.path = /opt/fm4app/bin

    desktop.path = /usr/share/applications
    desktop.files += fm4app.desktop

    icon.path = /opt/fm4app
    icon.files += fm4app.png
}

linux-g++-maemo5 {
    QT += opengl

    INSTALLS += target desktop icon

    target.path = /opt/fm4app/bin

    desktop.path = /usr/share/applications/hildon
    desktop.files += fm4app.desktop

    icon.path = /usr/share/icons/hicolor/scalable/apps
    icon.files += fm4app.png
}

symbian {
    DEPLOYMENT.display_name = "Radio FM4"
    TARGET.UID3 = 0x200398AC

    LIBS += -lcone -leikcore -lavkon
    ICON = fm4app.svg
}

OTHER_FILES += \
    Slider.qml \
    FM4App.qml


