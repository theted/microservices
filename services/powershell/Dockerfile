FROM alpine:3.24
RUN apk add --no-cache powershell
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.ps1 /app/
ENV STEP_CMD="pwsh -NoLogo -NoProfile -NonInteractive -File /app/collatz.ps1"
CMD ["runner"]
