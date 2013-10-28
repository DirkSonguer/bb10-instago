// include application class
#include "instago.hpp"

// include cascades classses
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <bb/cascades/LocaleHandler>
#include <bb/cascades/SceneCover>
#include <bb/device/DisplayInfo>

// use blackberry namespaces
using namespace bb::device;
using namespace bb::cascades;

Instago::Instago(bb::cascades::Application *app) :
        QObject(app)
{
	qmlRegisterType<QTimer>("QtTimer", 1, 0, "Timer");

	// The SceneCover is registered so that it can be used in QML
	qmlRegisterType<SceneCover>("bb.cascades", 1, 0, "SceneCover");

	// Since it is not possible to create an instance of the AbstractCover
	// it is registered as an uncreatable type (necessary for accessing
	// Application.cover).
	qmlRegisterUncreatableType<AbstractCover>("bb.cascades", 1, 0,
			"AbstractCover", "An AbstractCover cannot be created.");

    // prepare the localization
    m_pTranslator = new QTranslator(this);
    m_pLocaleHandler = new LocaleHandler(this);
    if(!QObject::connect(m_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()))) {
        // This is an abnormal situation! Something went wrong!
        // Add own code to recover here
        qWarning() << "Recovering from a failed connect()";
    }
    // initial load
    onSystemLanguageChanged();

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    // Retrieve the path to the app's working directory
    QString workingDir = QDir::currentPath();

    // Build the path, add it as a context property, and expose
    // it to QML
    QDeclarativePropertyMap* dirPaths = new QDeclarativePropertyMap;
    dirPaths->insert("currentPath", QVariant(QString(
            "file://" + workingDir)));
    dirPaths->insert("assetPath", QVariant(QString(
            "file://" + workingDir + "/app/native/assets/")));
    qml->setContextProperty("dirPaths", dirPaths);

	DisplayInfo display;
	int width = display.pixelSize().width();
	int height = display.pixelSize().height();

	QDeclarativePropertyMap* displayProperties = new QDeclarativePropertyMap;
	displayProperties->insert("width", QVariant(width));
	displayProperties->insert("height", QVariant(height));

	qml->setContextProperty("DisplayInfo", displayProperties);

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    app->setScene(root);
}

void Instago::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(m_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("InstagoBB10_%1").arg(locale_string);
    if (m_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(m_pTranslator);
    }
}
