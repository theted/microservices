FROM eclipse-temurin:25-jdk AS build
RUN apt-get update && apt-get install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*
ADD --checksum=sha256:7cc140e76daf416a0424a5557f99afd7ca89ebd463ea1101261e3e01c33e75cd \
    https://github.com/JetBrains/kotlin/releases/download/v2.4.21/kotlin-compiler-2.4.21.zip /kotlin.zip
RUN unzip -q /kotlin.zip -d /opt
COPY collatz.kt /src/
RUN /opt/kotlinc/bin/kotlinc /src/collatz.kt -include-runtime -d /collatz.jar

FROM eclipse-temurin:25-jre
COPY --from=build /collatz.jar /app/collatz.jar
CMD ["java", "-Xmx48m", "-XX:+UseSerialGC", "-jar", "/app/collatz.jar"]
