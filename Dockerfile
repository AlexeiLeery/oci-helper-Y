FROM maven:3-eclipse-temurin-21 AS builder

WORKDIR /app

COPY . .

RUN mvn clean package -DskipTests \
    && cp target/oci-helper-*.jar /app/oci-helper.jar

FROM eclipse-temurin:21-jre-jammy

ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    OCI_HELPER_VERSION=3.0.3

RUN apt update && apt install -y openssh-client lsof curl && \
    mkdir -p /root/.ssh && \
    echo "Host *\n  HostKeyAlgorithms +ssh-rsa\n  PubkeyAcceptedKeyTypes +ssh-rsa" > /root/.ssh/config && \
    chmod 700 /root/.ssh && chmod 600 /root/.ssh/config && \
    locale-gen zh_CN.UTF-8 && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

WORKDIR /app/oci-helper

COPY --from=builder /app/oci-helper.jar .

EXPOSE 8818

CMD exec java \
    --add-opens java.base/java.net=ALL-UNNAMED \
    --add-opens java.base/sun.net.www.protocol.https=ALL-UNNAMED \
    -jar oci-helper.jar | tee -a /var/log/oci-helper.log