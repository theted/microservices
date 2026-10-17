FROM alpine:3.24
RUN apk add --no-cache gnuplot
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.gp /app/
ENV STEP_CMD='gnuplot -c /app/collatz.gp "$N"'
CMD ["runner"]
