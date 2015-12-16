FROM ubuntu:14.04
MAINTAINER Arne Roomann-Kurrik <kurrik@gmail.com>

RUN apt-get update

RUN apt-get install -y \
    latex-xcolor \
    texlive-fonts-extra \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-math-extra \
    texlive-xetex

RUN apt-get install -y \
    curl \
    fontconfig \
    git \
    make \
    python \
    python-pip \
    uuid-runtime \
    wget

RUN apt-get install -y \
    xindy

RUN apt-get install -y \
    python-dev \
    libyaml-dev

RUN pip install PyYAML

WORKDIR /opt/lilypond
ADD lib/lilypond-2.19.20-1.linux-64.sh ./
RUN chmod +x *.sh
RUN ./lilypond-2.19.20-1.linux-64.sh --batch --prefix /opt/lilypond

WORKDIR /opt/laulik
ADD src/* ./
RUN chmod +x *.sh

ENTRYPOINT /opt/laulik/main.sh -
