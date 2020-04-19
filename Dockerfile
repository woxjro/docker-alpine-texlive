FROM alpine:3.11.5

LABEL maintainer="@woxjro"

WORKDIR /root/work

ENV PATH="/usr/local/texlive/latest/bin/x86_64-linuxmusl:${PATH}"

RUN apk update && apk add \
  fontconfig-dev \
  perl \
  tar \
  wget \
  xz

ADD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz /tmp/
RUN mkdir /tmp/install-tl-unx && \
  tar -xvf /tmp/install-tl-unx.tar.gz -C /tmp/install-tl-unx --strip-components=1 && \
  echo "selected_scheme scheme-basic" >> /tmp/install-tl-unx/texlive.profile && \
  /tmp/install-tl-unx/install-tl -profile /tmp/install-tl-unx/texlive.profile && \
  TEX_LIVE_VERSION=$(/tmp/install-tl-unx/install-tl --version | tail -n +2 | awk '{print $5}'); \
  ln -s "/usr/local/texlive/${TEX_LIVE_VERSION}" /usr/local/texlive/latest


RUN tlmgr install latexmk
COPY ./app/config/.latexmkrc /root/.latexmkrc
RUN tlmgr install multirow && \
  tlmgr install collection-langjapanese && \
  tlmgr install collection-fontsrecommended && \
  tlmgr install collection-fontutils

RUN apk del xz tar && \
  rm -rf /var/cache/apk/* && \
  rm -rf /tmp/*



