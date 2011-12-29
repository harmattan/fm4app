
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

#include <QtCore>
#include <QtGui>
#include <QtDeclarative>

#ifdef Q_WS_MAEMO_5
#include <QtOpenGL>
#endif

#ifdef Q_OS_SYMBIAN
#include <AknAppUi.h>
#endif

int main(int argc, char *argv[])
{
#ifdef Q_WS_MAEMO_5
    QApplication::setGraphicsSystem("raster");
#endif

    QApplication app(argc, argv);

#ifdef Q_OS_SYMBIAN
    CAknAppUi* appUi = dynamic_cast<CAknAppUi*> (CEikonEnv::Static()->AppUi());
    appUi->SetOrientationL(CAknAppUi::EAppUiOrientationPortrait);
#endif

    QDeclarativeView view;
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);

#ifdef Q_WS_MAEMO_5
    view.engine()->addImportPath(QString("/opt/qtm11/imports"));
    view.engine()->addPluginPath(QString("/opt/qtm11/plugins"));
    view.setAttribute(Qt::WA_Maemo5PortraitOrientation);
    view.setViewport(new QGLWidget);

    view.setViewportUpdateMode(QGraphicsView::FullViewportUpdate);

    view.setAttribute(Qt::WA_OpaquePaintEvent);
    view.setAttribute(Qt::WA_NoSystemBackground);

    view.viewport()->setAttribute(Qt::WA_OpaquePaintEvent);
    view.viewport()->setAttribute(Qt::WA_NoSystemBackground);
#endif

#if defined(Q_OS_SYMBIAN)
    view.rootContext()->setContextProperty("scaling", 1.5);
#elif defined(Q_OS_MAEMO) || defined(Q_WS_MAEMO_5)
    view.rootContext()->setContextProperty("scaling", 2.0);
#else
    view.rootContext()->setContextProperty("scaling", 1.0);
#endif

#if defined(Q_OS_MAEMO)
    /* Harmattan aka MeeGo 1.2 */
    view.rootContext()->setContextProperty("isHarmattan", true);
    view.rootContext()->setContextProperty("isFremantle", false);
#elif defined(Q_WS_MAEMO_5)
    /* Fremantle aka Maemo 5 */
    view.rootContext()->setContextProperty("isHarmattan", true);
    view.rootContext()->setContextProperty("isFremantle", true);
#else
    /* Symbian aka Uhh */
    view.rootContext()->setContextProperty("isHarmattan", false);
    view.rootContext()->setContextProperty("isFremantle", false);
#endif

#if defined(Q_OS_MAEMO)
    view.setSource(QUrl("qrc:/harmattan.qml"));
#else
    view.setSource(QUrl("qrc:/FM4App.qml"));
#endif

    QObject::connect(view.engine(), SIGNAL(quit()),
                     &view, SLOT(close()));

#if defined(Q_OS_SYMBIAN) || defined(Q_OS_MAEMO) || defined(Q_WS_MAEMO_5)
    view.showFullScreen();
#else
    view.show();
#endif

    return app.exec();
}

