# BUILD
FROM golang:1.20-alpine as build
WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o /app/main .

# RUN
FROM alpine:latest
RUN apk add --update --no-cache ca-certificates
WORKDIR /app

ENV PUT2ARIA_LISTEN=0.0.0.0:8000
EXPOSE 8000

COPY --from=build /app/main .
CMD ["/app/main"]
