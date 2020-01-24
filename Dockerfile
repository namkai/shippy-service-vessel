FROM golang:alpine as builder

RUN apk update && apk upgrade && \
  apk add --no-cache git

RUN mkdir /app
WORKDIR /app

ENV CGO_ENABLED=0
ENV GO111MODULE=on

COPY . .

RUN go get
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-vessel


FROM alpine:latest

RUN apk --no-cache add ca-certificates

RUN mkdir /app
WORKDIR /app
COPY --from=builder /app/shippy-service-vessel .

CMD ["./shippy-service-vessel"]