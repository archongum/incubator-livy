FROM maven:3-eclipse-temurin-8 as builder

COPY ./ /workdir

WORKDIR /workdir

RUN set -eux \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    unzip \
  && mvn package -DskipTests -Phadoop3 -Pspark3 -Pscala-2.12 -pl '!integration-test,!python-api,!examples,!coverage' \
  && mkdir -p /tmp/package \
  && mv ./assembly/target/apache-livy-*.zip /apache-livy.zip \
  && unzip /apache-livy.zip -d /tmp \
  && mv /tmp/apache-livy-*/ /tmp/livy

# ------------------------- #

FROM busybox
COPY --from=builder /tmp/livy /tmp/livy
