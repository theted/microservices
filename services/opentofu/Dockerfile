FROM alpine:3.24
RUN apk add --no-cache opentofu
COPY collatz.tf /app/
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD='echo local.next | tofu -chdir=/app console -var "n=$N"' TF_IN_AUTOMATION=1
CMD ["runner"]
