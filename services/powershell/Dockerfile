FROM alpine:3.24
RUN apk add --no-cache powershell
COPY collatz.ps1 /app/
CMD ["pwsh", "-NoLogo", "-NoProfile", "-File", "/app/collatz.ps1"]
