FROM golang:1.17-alpine

ENV GO111MODULE=on

WORKDIR /app

COPY . .
 
# Budild application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build
 
ENTRYPOINT ["/app/hello-world-client"]
