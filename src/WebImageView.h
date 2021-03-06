// Source: https://github.com/RileyGB/BlackBerry10-Samples/tree/master/WebImageViewSample

#ifndef WEBIMAGEVIEW_H_
#define WEBIMAGEVIEW_H_

#include <bb/cascades/ImageView>
#include <QNetworkAccessManager>
#include <QNetworkDiskCache>
#include <QUrl>
using namespace bb::cascades;

class WebImageView: public bb::cascades::ImageView {
	Q_OBJECT
	Q_PROPERTY (QUrl url READ url WRITE setUrl NOTIFY urlChanged)
	Q_PROPERTY (float loading READ loading NOTIFY loadingChanged)

public:
	WebImageView();
	const QUrl& url() const;
	double loading() const;

	public Q_SLOTS:
	void setUrl(const QUrl& url);

	private Q_SLOTS:
	void imageLoaded();
	void dowloadProgressed(qint64,qint64);

	signals:
	void urlChanged();
	void loadingChanged();


private:
	static QNetworkAccessManager * mNetManager;
	static QNetworkDiskCache * mNetworkDiskCache;
	QUrl mUrl;
	float mLoading;
};

#endif /* WEBIMAGEVIEW_H_ */
