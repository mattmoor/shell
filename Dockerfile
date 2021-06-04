FROM golang as builder

# Do this because the project is too old for "go install" without some help.
WORKDIR /go/src/github.com/mattmoor/shell
ADD . .
RUN CGO_ENABLED=0 go install github.com/yudai/gotty
ENTRYPOINT [ "gotty" ]

# Install the stuff we want in the environment.
RUN apt-get update && apt-get install -y -qq --no-install-recommends git nano less curl tmux

ARG K8S_VERSION=1.20.0
ARG MINK_VERSION=0.21.1
ARG TARGETARCH=arm64

RUN curl -LO https://dl.k8s.io/release/v${K8S_VERSION}/bin/linux/${TARGETARCH}/kubectl && \
    chmod +x ./kubectl && \
    mv kubectl /usr/local/bin
RUN curl -L https://github.com/mattmoor/mink/releases/download/v${MINK_VERSION}/mink_${MINK_VERSION}_Linux_${TARGETARCH}.tar.gz | tar xzf - mink_${MINK_VERSION}_Linux_${TARGETARCH}/mink && \
    chmod +x ./mink_${MINK_VERSION}_Linux_${TARGETARCH}/mink && \
    mv mink_${MINK_VERSION}_Linux_${TARGETARCH}/mink /usr/local/bin && \
    rm -rf mink_${MINK_VERSION}_Linux_${TARGETARCH}/

RUN mv gitconfig /etc/gitconfig
RUN git config --global user.email "not@val.id"
RUN git config --global user.name "minkoku"

# The one true command-line editor.
# TODO(mattmoor): switch to emacs
ENV EDITOR=nano
ENV TERM=linux

WORKDIR /go/src