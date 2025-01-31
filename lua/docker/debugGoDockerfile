ARG GO_VERSION=1.23.1
FROM golang:${GO_VERSION} as golang

FROM base/image:latest

COPY --from=golang /usr/local/go /usr/local/go

ENV PATH="${PATH}:/usr/local/go/bin:/root/go/bin"

RUN export PATH

RUN go env -w GOPROXY="https://goproxy.cn,direct"

RUN go env -w GOROOT="/usr/local/go" GOPATH="/root/go"

RUN go install github.com/go-delve/delve/cmd/dlv@latest

WORKDIR /root

CMD ["dlv","dap","-l","0.0.0.0:38697","--log","--log-output=dap"]
