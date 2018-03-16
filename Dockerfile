FROM ubuntu

MAINTAINER Roberto Falk <roberto.falk@gmail.com>

ENV LANGUAGE=C.UTF-8 LC_ALL=C.UTF-8 LANG=C.UTF-8
ENV PROXY_SERVER http://proxy.wdf.sap.corp:8080
ENV http_proxy $PROXY_SERVER
ENV https_proxy $PROXY_SERVER
ENV ftp_proxy $PROXY_SERVER
ENV all_proxy $PROXY_SERVER
ENV HTTP_PROXY $PROXY_SERVER
ENV HTTPS_PROXY $PROXY_SERVER
ENV FTP_PROXY $PROXY_SERVER
ENV ALL_PROXY $PROXY_SERVER
ENV no_proxy localhost,127.0.0.1,*.local,169.254/16,*.sap.corp,*.corp.sap,.sap.corp,.corp.sap
ENV NO_PROXY localhost,127.0.0.1,*.local,169.254/16,*.sap.corp,*.corp.sap,.sap.corp,.corp.sap

RUN apt-get update && apt-get install -y autoconf autoconf-archive automake build-essential checkinstall cmake g++ git libcairo2-dev libcairo2-dev libicu-dev libicu-dev libjpeg8-dev libjpeg8-dev libpango1.0-dev libpango1.0-dev libpng12-dev libpng12-dev libtiff5-dev libtiff5-dev libtool pkg-config wget xzgv zlib1g-dev python3-pip

WORKDIR /root

RUN git clone https://github.com/DanBloomberg/leptonica.git
RUN git clone https://github.com/tesseract-ocr/tesseract.git

RUN cd leptonica/ && \
	autoreconf -vi && ./autobuild && ./configure && \
	make && make install && \
	cd .. && \
	cd tesseract/ && \
	./autogen.sh && ./configure --disable-openmp && \
	LDFLAGS="-L/usr/local/lib" CFLAGS="-I/usr/local/include" make && \
	make && \
	make install && ldconfig

WORKDIR /usr/local/share/tessdata/
RUN wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/osd.traineddata && \
   	wget https://github.com/tesseract-ocr/tessdata/raw/3.04.00/equ.traineddata && \
   	wget https://github.com/tesseract-ocr/tessdata/raw/4.00/eng.traineddata && \
   	wget https://github.com/tesseract-ocr/tessdata/raw/4.00/deu.traineddata