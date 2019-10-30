!include( ../examples.pri ) {
    error( "Couldn't find the examples.pri file!" )
}
QT += sensors
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

RESOURCES += qmlbars.qrc \
    qmlbars.qrc

OTHER_FILES += doc/src/* \
               doc/images/* \
               qml/qmlbars/*

DISTFILES += \
    qml/qmlbars/Acceler.qml \
    qml/qmlbars/Directions.qml \
    qml/qmlbars/Magnet.qml
