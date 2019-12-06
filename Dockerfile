FROM ubuntu:14.04
MAINTAINER Arne Roomann-Kurrik <kurrik@gmail.com>

# LaTeX stuff.
RUN apt-get update && apt-get install -y --fix-missing \
    latex-xcolor \
    texlive-fonts-extra \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-math-extra \
    texlive-xetex \
    xindy

# Python / dev
RUN apt-get update && apt-get install -y --fix-missing \
    curl \
    fontconfig \
    git \
    make \
    libyaml-dev \
    python3 \
    python3-dev \
    python3-pip \
    uuid-runtime \
    wget

RUN pip3 install Flask
RUN pip3 install PyYAML
RUN pip3 install pystache
RUN pip3 install ansi2html

RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

WORKDIR /opt/lilypond
ADD lib/lilypond-2.19.20-1.linux-64.sh ./
RUN chmod +x *.sh
RUN ./lilypond-2.19.20-1.linux-64.sh --batch --prefix /opt/lilypond

RUN pip3 install Flask gunicorn

WORKDIR /opt/laulik
ADD src ./src
ADD VERSION VERSION
RUN chmod +x ./src/main.sh
RUN chmod +x ./src/server/*.sh
RUN chmod +x ./src/compiler/laulik.sh

ENTRYPOINT /opt/laulik/src/main.sh
