FROM golang:1 AS build
WORKDIR /go/src
RUN git clone https://github.com/drone/drone .
ARG TAG=master
RUN if [ -n "${TAG#master}" ]; then git checkout tags/$TAG -b $TAG; fi
ENV CGO_ENABLED=0
ENV GOOS=linux 
ENV GOARCH=amd64
RUN go install -tags "nolimit" github.com/drone/drone/cmd/drone-agent
RUN go install -tags "nolimit" github.com/drone/drone/cmd/drone-controller
RUN go install -tags "nolimit" github.com/drone/drone/cmd/drone-server
RUN cd /go/bin; for file in $(ls); do mv ${file} ${file#drone-}; done

FROM alpine:3
RUN apk add --no-cache ca-certificates
RUN if [ ! -e /etc/nsswitch.conf ]; then echo 'hosts: files dns' > /etc/nsswitch.conf; fi
ENV GODEBUG netdns=go
ENV DRONE_RUNNER_OS=linux
ENV DRONE_RUNNER_ARCH=amd64
ENV DRONE_RUNNER_PLATFORM=linux/amd64
COPY --from=build /go/bin/* /usr/local/bin/
ENTRYPOINT []
