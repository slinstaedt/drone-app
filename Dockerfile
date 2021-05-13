FROM drone/drone AS trigger

FROM golang:1 AS build
WORKDIR /go/src
COPY . .
ENV CGO_ENABLED=0
ENV GOOS=linux 
ENV GOARCH=amd64
RUN go install -tags "nolimit" github.com/drone/drone/cmd/drone-server

FROM alpine:3
RUN apk add --no-cache ca-certificates
RUN if [ ! -e /etc/nsswitch.conf ]; then echo 'hosts: files dns' > /etc/nsswitch.conf; fi
ENV GODEBUG netdns=go
ENV DRONE_RUNNER_OS=linux
ENV DRONE_RUNNER_ARCH=amd64
ENV DRONE_RUNNER_PLATFORM=linux/amd64
ENV DRONE_DATADOG_ENABLED=false
COPY --from=build /go/bin/drone-server /usr/local/bin/
EXPOSE 8080
ENTRYPOINT ["drone-server"]
