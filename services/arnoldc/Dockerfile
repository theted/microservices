FROM eclipse-temurin:25-jre
RUN apt-get update && apt-get install -y --no-install-recommends socat && rm -rf /var/lib/apt/lists/*
# The 2014 compiler, still hosted on the author's GitHub Pages (there are no GitHub releases).
ADD --checksum=sha256:c26b0342d352e69838bc7dab67305484edaca702002cf793f61f817d9dc1c31d \
    https://lhartikk.github.io/ArnoldC.jar /opt/ArnoldC.jar
WORKDIR /app
COPY collatz.arnoldc .
RUN java -jar /opt/ArnoldC.jar collatz.arnoldc && rm /opt/ArnoldC.jar
COPY --from=shim . /shim/
ENV STEP_CMD="java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -cp /app collatz"
CMD ["/shim/serve"]
