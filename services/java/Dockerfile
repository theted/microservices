FROM eclipse-temurin:25-jdk AS build
COPY CollatzEnterpriseEdition.java /src/
RUN javac -d /classes /src/CollatzEnterpriseEdition.java

FROM eclipse-temurin:25-jre
COPY --from=build /classes /app
CMD ["java", "-Xmx48m", "-XX:+UseSerialGC", "-cp", "/app", "CollatzEnterpriseEdition"]
