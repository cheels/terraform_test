#!/bin/bash
set -x

HZ_VERSION=$1
LICENSE_KEY=$2
MEMBERS=$3


HZ_JAR_URL=https://hazelcast.jfrog.io/artifactory/release/com/hazelcast/hazelcast-enterprise/${HZ_VERSION}/hazelcast-enterprise-${HZ_VERSION}.jar

mkdir -p ${HOME}/jars
mkdir -p ${HOME}/logs

pushd ${HOME}/jars
    echo "Downloading JARs..."
    if wget -q "$HZ_JAR_URL"; then
        echo "Hazelcast JAR downloaded succesfully."
    else
        echo "Hazelcast JAR could NOT be downloaded!"
        exit 1;
    fi
popd

sed -i -e "s/LICENSE_KEY/${LICENSE_KEY}/g" ${HOME}/hazelcast.yaml
sed -i -e "s/MEMBERS/${MEMBERS}/g" ${HOME}/hazelcast.yaml


nohup java -Dhazelcast.enterprise.license.key=${LICENSE_KEY} -Dhazelcast.config=/home/ubuntu/hazelcast.yaml -jar /home/ubuntu/jars/hazelcast-enterprise-${HZ_VERSION}.jar &>> ${HOME}/logs/hazelcast.logs &
sleep 5


