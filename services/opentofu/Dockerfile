FROM alpine:3.24
RUN apk add --no-cache opentofu socat
COPY collatz.tf /app/
COPY --from=shim . /shim/
ENV STEP_CMD='echo local.next | tofu -chdir=/app console -var "n=$N"' TF_IN_AUTOMATION=1
CMD ["/shim/serve"]
