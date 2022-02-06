FROM golang:1.16-alpine as builder

RUN go get -v -u github.com/FreifunkBremen/yanic@2c0b3c74fc42efb3e91a88939d341ed73c65d31a

FROM alpine:3.14
COPY --from=builder /go/bin/yanic /bin/yanic
RUN apk add --update --no-cache bash
ADD entrypoint.sh /entrypoint.sh
VOLUME /data

CMD /entrypoint.sh