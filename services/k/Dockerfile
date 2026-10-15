FROM alpine:3.24 AS build
RUN apk add --no-cache gcc musl-dev make
ADD https://codeberg.org/ngn/k/archive/b9eeb91e0343ef6029f59d55dd98f82667b9bd59.tar.gz /tmp/k.tar.gz
RUN mkdir /k && tar -xzf /tmp/k.tar.gz -C /k --strip-components=1 && make -C /k k

FROM alpine:3.24
COPY --from=build /k/k /usr/local/bin/k
COPY --from=runner /runner /usr/local/bin/runner
COPY collatz.k /app/
ENV STEP_CMD="k /app/collatz.k"
CMD ["runner"]
