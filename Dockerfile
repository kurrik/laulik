FROM ubuntu:20.04
MAINTAINER Arne Roomann-Kurrik <kurrik@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# Setup
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg

# Python / dev
RUN apt-get update && apt-get install -y --fix-missing \
    curl \
    fontconfig \
    git \
    libyaml-dev \
    make \
    python3 \
    python3-dev \
    python3-pip \
    rsync \
    uuid-runtime \
    wget

RUN pip3 install \
    Flask \
    PyYAML \
    pystache \
    ansi2html \
    gunicorn \
    glom

# Fix locale
RUN apt-get clean && apt-get -y update && apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# LaTeX stuff.
RUN apt-get update && apt-get install -y --fix-missing \
    lilypond \
    texlive-latex-recommended \
    texlive-fonts-extra \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-science \
    texlive-science-doc \
    texlive-xetex \
    xindy

# Application setup
WORKDIR /opt/laulik
ADD src ./src
ADD VERSION VERSION
RUN chmod +x ./src/main.sh
RUN chmod +x ./src/server/*.sh
RUN chmod +x ./src/compiler/laulik.sh

ENTRYPOINT ["/opt/laulik/src/main.sh"]
