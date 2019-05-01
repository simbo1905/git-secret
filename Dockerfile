FROM alpine:latest

RUN apk add --no-cache --update \
	bash \
	build-base \
	coreutils \
	curl \
	findutils \
	gcc \
	libffi-dev \
	musl-dev \
	net-tools \
	openrc \
	openssh \
	openssh-server \
	openssh-sftp-server \
	openssl-dev \
	py-boto \
	py2-pip \
	python2-dev \
	rsyslog \
	sudo \
	xz \
 && pip install --upgrade pip 

RUN apk add vim

EXPOSE 22
