/*
 * WebImageView.cpp
 *
 *  Created on: 4 oct. 2012
 *      Author: schutz
 */

#include "WebImageView.h"
#include <bb/cascades/Image>

QNetworkAccessManager * WebImageView::mNetManager = new QNetworkAccessManager;

WebImageView::WebImageView() {
	mLoading = 0;
}

const QUrl& WebImageView::url() const {
	return mUrl;
}

void WebImageView::setUrl(const QUrl& url) {
	mUrl = url;
	mLoading = 0;
	QNetworkReply * reply = mNetManager->get(QNetworkRequest(url));
	connect(reply, SIGNAL(finished()), this, SLOT(imageLoaded()));
	connect(reply, SIGNAL(downloadProgress(qint64, qint64)), this,
			SLOT(dowloadProgressed(qint64, qint64)));
	emit urlChanged();
}

double WebImageView::loading() const {
	return mLoading;
}

void WebImageView::imageLoaded() {

	QNetworkReply * reply = qobject_cast<QNetworkReply*>(sender());
	setImage(Image(reply->readAll()));

	reply->deleteLater();

}

void WebImageView::dowloadProgressed(qint64 bytes, qint64 total) {

	mLoading = double(bytes) / double(total);
	emit loadingChanged();

}

