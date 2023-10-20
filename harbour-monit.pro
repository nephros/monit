TEMPLATE = aux
TARGET = harbour-monit
CONFIG += sailfishapp sailfishapp_qml

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
#INCLUDEPATH += .
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

QMAKE_EXTRA_TARGETS += ts
ts.commands = lupdate *.pro

# sailfishapp has this already:
OTHER_FILES += $$files(rpm/*)

# NOTE: do not include TEMPLATE declarations in .pro files!
include(translations/translations.pri)
include(sailjail/sailjail.pri)
include(icons/icons.pri)
include(clean.pri)
