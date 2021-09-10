FROM debezium/connect-base:0.10

LABEL maintainer="Debezium Community"

ENV DEBEZIUM_VERSION="0.10.0.CR1" \
    MAVEN_REPO_CENTRAL="" \
    MAVEN_REPO_INCUBATOR="" \
    MAVEN_DEP_DESTINATION=$KAFKA_CONNECT_PLUGINS_DIR \
    POSTGRES_MD5=c5b920c79d8e96cbab9bac9cc733cdb9

RUN docker-maven-download debezium postgres "$DEBEZIUM_VERSION" "$POSTGRES_MD5"
