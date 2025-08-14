FROM golang:1.22.5-alpine AS builder
WORKDIR /app
ENV CGO_ENABLED=0
ENV GOOS=linux
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -ldflags="-w -s" -o /app/main .
FROM gcr.io/distroless/static-debian11
WORKDIR /app
COPY --from=builder /app/main .

EXPOSE 8080
USER 65532:65532
CMD ["/app/main"]
