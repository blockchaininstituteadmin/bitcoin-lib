FROM openjdk:8-jdk-alpine

RUN apk add maven git

WORKDIR /src/bitcoin-lib

COPY pom.xml /src/bitcoin-lib/pom.xml
RUN mvn verify clean --fail-never

ADD . /src/bitcoin-lib
RUN mvn package
