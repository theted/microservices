FROM eclipse-temurin:25-jdk AS build
COPY CollatzEnterpriseEdition.java /src/
RUN javac -d /classes /src/CollatzEnterpriseEdition.java

FROM eclipse-temurin:25-jre
COPY --from=runner /runner /usr/local/bin/runner
COPY --from=build /classes /app
ENV STEP_CMD="java -XX:TieredStopAtLevel=1 -XX:+UseSerialGC -Xshare:auto -cp /app CollatzEnterpriseEdition"
CMD ["runner"]
