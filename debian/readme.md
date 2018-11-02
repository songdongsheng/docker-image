# Docker 打包
## 当前 4 个容器
1. ldc-pa：DB，ES，ZooKeeper，Kafka。 (加载生产数据后 3.82 GB，加载平台数据后 1.45 GB)
2. ldc-api：后端服务。后续会根据服务拆分情况，拆分为多个容器。(578 MB)
3. ldc-scg: Spring Cloud Gateway。(272 MB)
4. ldc-www: 前端静态网站。(170 MB)

基础容器采用 debian:9-slim，它只有 55 MB (压缩后 22 MB)。作为参考，centos:7 是 111 MB (压缩后 74.7 MB)。

## 基础 JRE 容器 [ok]
263 MB，压缩后 97 MB。
### server-jre/docker-setup.sh
1. 继承 docker.io/debian:9-slim 55.3 MB
2. 修改时区为 Asia/Shanghai，替换默认的 UTC
3. 配置默认编码为 UTF-8，替换默认的 ISO-88959-1。
    修改 Dockerfile 和 /etc/default/locale。
4. 系统更新
5. 增加 UTF-8 编码支持的数据文件
6. 增加 server-jre 8u192

## 持久化容器 (DB，ES，ZooKeeper，Kafka) [ok]
### ldc-pa/docker-setup.sh
1. 安装 gnupg
2. 增加 PostgreSQL 的公钥 0x7FCC7D46ACCC4CF8.asc
3. 安装 PostgreSQL 10，更新 PATH 配置
4. 增加操作系统资源配置文件 limits.conf
5. 增加 PostgreSQL 的配置文件 pg_hba.conf，postgresql.conf
6. 启动 PostgreSQL
7. 创建数据库和用户
8. 导入表定义
9. 导入表数据
10. 增加 ES 的配置文件 jvm.options
11. 启动 ES
12. 从数据库导出数据到 ES
13. 刷新系统缓存，关闭数据库和 ES
14. 增加 ZooKeeper 的配置文件 zoo.cfg
15. 增加 Kafka 的配置文件 server.properties
16. 开放 PostgreSQL，ES，ZooKeeper 和 Kafka 的服务端口

### ldc-pa/ldc_entry.sh
1. 启动 ES
2. 启动 PostgreSQL
3. 启动 ZooKeeper
4. 启动 Kafka
5. 完成

## 后端服务
### ldc-api/ldc-api-entry.sh
1. 启动主应用
2. 启动组合调用
3. 启动消息推送
4. 启动工作流
5. 启动OLAP

### 服务拆分
1. 为每个 API 定义归属的服务
2. 为每个表定义归属的服务
3. API 路径映射到归属的服务的规则，整理清楚

## Spring Cloud Gateway
### ldc-scg/ldc-scg-entry.sh
1. 内置路由规则
2. 读取服务的注册，动态配置路由规则
3. 读取中央配置，动态配置路由规则

## ldc-www/前端静态网站
1. 提供 PC 端网站
2. 提供移动端网站
