FROM ubuntu:18.04
MAINTAINER Ben Whitten <ben.whitten@gmail.com>
LABEL Description="Image for building mbed projects with the GNU Arm Embedded toolchain"

RUN 	apt-get update && apt-get install -y \
	wget \
	curl \
	git \
	mercurial \
	openssl \
	build-essential \
	python \
	python-pip \
	&& pip install mbed-cli

RUN	mkdir /toolchain  && cd /toolchain  && wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2018q4/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 -O - | tar -xj
RUN	mbed config -G GCC_ARM_PATH "/toolchain/gcc-arm-none-eabi-8-2018-q4-major/bin/"  && mbed toolchain -G GCC_ARM

RUN 	cd /tmp && mbed new tmp0 && cd tmp0 && mbed compile >/dev/null 2>&1; cd .. && rm -r /tmp/tmp0

RUN	pip install intervaltree fuzzywuzzy

WORKDIR /mbed
VOLUME /mbed

ENTRYPOINT [ "/usr/local/bin/mbed" ]
