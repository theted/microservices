FROM eclipse-temurin:25-jre
# The 2014 compiler, still hosted on the author's GitHub Pages (there are no GitHub releases).
ADD --checksum=sha256:c26b0342d352e69838bc7dab67305484edaca702002cf793f61f817d9dc1c31d \
    https://lhartikk.github.io/ArnoldC.jar /opt/ArnoldC.jar
WORKDIR /app
COPY collatz.arnoldc .
RUN java -jar /opt/ArnoldC.jar collatz.arnoldc && rm /opt/ArnoldC.jar
COPY --from=runner /runner /usr/local/bin/runner
ENV STEP_CMD="java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -cp /app collatz"
CMD ["runner"]
