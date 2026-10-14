FROM alpine:3.24
RUN apk add --no-cache R
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.R /app/
ENV STEP_CMD="Rscript /app/collatz.R"
CMD ["runner"]
