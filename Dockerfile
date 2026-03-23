# ── Stage 1: Build ──────────────────────────────────────
FROM golang:1.22-alpine AS builder
# Install build dependencies
RUN apk add --no-cache git
WORKDIR /app
# Cache dependencies first (layer caching optimisation)
COPY go.mod go.sum ./
RUN go mod download
# Copy source and build a static binary
COPY app/ ./app/
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-w -s" \
    -o myapp ./app/main.go
# ── Stage 2: Runtime ─────────────────────────────────────
FROM gcr.io/distroless/static-debian12
# Non-root user for security
USER nonroot:nonroot
WORKDIR /
COPY --from=builder /app/myapp .
# Port must match containerPort in deployment YAMLs
EXPOSE 8080
# Health check — Kubernetes readinessProbe also hits /health
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD ["/myapp", "--healthcheck"]
ENTRYPOINT ["/myapp"]