# syntax=docker/dockerfile:1
# Runtime = imagem publicada em GHCR.
FROM ghcr.io/jorgehenrrique/pro-ticket-bot:latest
COPY VERSION /etc/pro-ticket/VERSION
