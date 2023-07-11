
TARGET = harbour-monit
CONFIG += sailfishapp sailfishapp_i18n
INCLUDEPATH += .

QT =

lupdate_only {
SOURCES += \
    qml/$${TARGET}.qml \
    qml/pages/*.qml \
    qml/cover/*.qml \
    qml/components/*.qml \
    qml/components/*/*.qml \
    qml/external/opal-about/Opal/About/*.qml\
    qml/external/opal-about/Opal/About/private/*.qml

}

# if we have a binary:
#SOURCES += src/main.cpp

TRANSLATIONS += translations/$${TARGET}-en.ts \
                translations/$${TARGET}-de.ts \
                translations/$${TARGET}-sv.ts \

desktop.files = $${TARGET}.desktop
desktop.path = $$PREFIX/share/applications
INSTALLS += desktop

qml.files = qml
qml.path = $$PREFIX/share/$${TARGET}

INSTALLS += qml

OTHER_FILES += $$files(rpm/*)

include(translations/translations.pri)
include(sailjail/sailjail.pri)
# must be last
include(icons/icons.pri)
