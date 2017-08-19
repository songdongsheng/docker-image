#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SOURCE_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#if [ ! -f ${SOURCE_DIR}/pool/cn.abrain.backend.api-bohandler-1.2.jar ]; then
(
cd ${SOURCE_DIR}/../api/
mvn -Dmaven.test.skip=true clean package
/usr/bin/cp \
    bohandler/target/cn.abrain.backend.api-bohandler-1.2.jar \
    child-relation-handler/target/cn.abrain.backend.api-child-relation-handler-1.0.jar \
    composite/target/cn.abrain.backend.api-composite-1.0.jar \
    jdbcdao/target/cn.abrain.backend.api-jdbcdao-1.0.jar \
    linkhandler/target/cn.abrain.backend.api-linkhandler-1.0.jar \
    mappinghandler/target/cn.abrain.backend.api-mappinghandler-1.0.jar \
    rbachandler/target/cn.abrain.backend.api-rbachandler-1.0.jar \
    usermgr/target/cn.abrain.backend.api-usermgr-1.0.jar \
    validatesync/target/cn.abrain.backend.api-validatesync-1.0.jar \
    viewhandler/target/cn.abrain.backend.api-viewhandler-1.0.jar \
    ${SOURCE_DIR}/pool
)
#fi

if [ ! -f ${SOURCE_DIR}/pool/elasticsearch-2.4.5-with-plugins.tgz ]; then
curl -sS -o ${SOURCE_DIR}/pool/elasticsearch-2.4.5-with-plugins.tgz \
    https://baas.songdongsheng.info/download/elasticsearch-2.4.5-with-plugins.tgz
fi

if [ ! -f ${SOURCE_DIR}/pool/para-1.24.6-SNAPSHOT.war ]; then
curl -sS -o ${SOURCE_DIR}/pool/para-1.24.6-SNAPSHOT.war \
    https://baas.songdongsheng.info/download/para-1.24.6-SNAPSHOT.war
fi

if [ ! -f ${SOURCE_DIR}/pool/server-jre-8u144-linux-x64-with-jce.tar.gz ]; then
curl -sS -o ${SOURCE_DIR}/pool/server-jre-8u144-linux-x64-with-jce.tar.gz \
    https://baas.songdongsheng.info/download/jdk-8u144/server-jre-8u144-linux-x64-with-jce.tar.gz
fi

TS=`/bin/date +"%Y%m%d_%H%M%S"`

docker build -t songdongsheng/bass:${TS} .
docker tag      songdongsheng/bass:${TS} songdongsheng/bass:latest
