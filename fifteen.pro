TEMPLATE = app

QT += qml quick widgets

SOURCES += main.cpp \
    highscorelistmodel.cpp \
    highscoreentry.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    highscorelistmodel.h \
    highscoreentry.h
