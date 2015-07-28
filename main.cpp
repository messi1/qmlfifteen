#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuick/QQuickView>
#include <highscorelistmodel.h>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    HighScoreListModel model;
//    model.saveHighScoreList();
    model.loadHighScoreList();

    QQuickView viewer;
    viewer.rootContext()->setContextProperty("myModel", &model);
    viewer.setSource(QUrl(QStringLiteral("qrc:/main.qml")));
    viewer.show();
    app.setApplicationName("QmlFifteen");
    app.setOrganizationName("JPM");
    app.setApplicationVersion("1.0");

    QObject::connect((QObject*)viewer.engine(), SIGNAL(quit()), &app, SLOT(quit()));

    return app.exec();
}
