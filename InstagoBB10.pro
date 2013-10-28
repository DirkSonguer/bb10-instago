APP_NAME = InstagoBB10

CONFIG += qt warn_on cascades10

QT += network

LIBS += -lbbdevice -lbbplatform -lbbcascadesmaps -lGLESv1_CM -lQtLocationSubset

include(config.pri)
