# build
FROM golang:1.18.7-alpine3.16 as builder
RUN mkdir /api
COPY ./cmd /api/cmd
COPY ./vendor /api/vendor
COPY ./go.mod /api/go.mod
COPY ./go.sum /api/go.sum

WORKDIR /api
RUN CGO_ENABLED=0 GOOS=linux go build -mod=vendor -o /api/api /api/cmd/main.go

# image api
FROM alpine:3.16.2 as api
WORKDIR /api
COPY --from=builder /api/api /api/api

WORKDIR /api
RUN chmod +x /api/api

CMD ["/api/api"]
