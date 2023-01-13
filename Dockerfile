FROM docker.io/alpine:3 AS builder

RUN apk --no-cache add ca-certificates

FROM scratch
ARG WEBHOOK_ARTIFACT_PATH="./webhook"
# CA file location from https://go.dev/src/crypto/x509/root_linux.go
ARG CA_BUNDLE_PATH="/etc/ssl/certs/ca-certificates.crt"

COPY --chmod=755 "${WEBHOOK_ARTIFACT_PATH}" /usr/local/bin/webhook
COPY --from=builder "${CA_BUNDLE_PATH}" "${CA_BUNDLE_PATH}"

USER 1001:1001

ENTRYPOINT ["/usr/local/bin/webhook"]
