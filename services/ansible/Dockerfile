FROM alpine:3.24
RUN apk add --no-cache ansible-core
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.yml /app/
ENV STEP_CMD='ansible-playbook -i localhost, -c local -e n="$N" /app/collatz.yml' \
    ANSIBLE_STDOUT_CALLBACK=minimal
CMD ["runner"]
