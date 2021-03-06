FROM centos:latest
MAINTAINER Debasish Nath <nath.debasish@gmail.com>

RUN yum install -y \
   curl \
   which \
   java-1.8.0-openjdk \
   java-1.8.0-openjdk-devel

COPY kafka/confluent.repo /etc/yum.repos.d
COPY start.sh /root/start.sh

RUN rpm --import https://packages.confluent.io/rpm/5.3/archive.key && \
    yum clean all && \
    yum -y install confluent-platform-2.12 && \
    curl -L -o /tmp/kafka-connect-twitter.tar.gz https://github.com/jcustenborder/kafka-connect-twitter/releases/download/0.2.26/kafka-connect-twitter-0.2.26.tar.gz && \
    tar -xvf /tmp/kafka-connect-twitter.tar.gz --strip=3 -C /usr/share/java && \
    rm -f /tmp/kafka-connect-twitter.tar.gz

COPY kafka/properties/brokers/* /etc/kafka/
COPY kafka/properties/connector/* /etc/kafka/
COPY kafka/properties/schema-registry/* /etc/schema-registry/
COPY kafka/properties/control-center/* /etc/confluent-control-center/
COPY kafka/data/connector-file-source.txt /etc/kafka/
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk/

EXPOSE 2181 9021 9092 9094 9096 9098

CMD ["/bin/bash", "/root/start.sh"]
