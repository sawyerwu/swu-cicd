登陆mysql后执行下面语句给exporter用户授权
```
CREATE USER 'exporter'@'%' IDENTIFIED BY '123456';
GRANT PROCESS, REPLICATION CLIENT ON *.* TO 'exporter'@'%';
GRANT SELECT ON performance_schema.* TO 'exporter'@'%';
```

修改internal.yaml中关于mysql的配置，kubectl apply 即可。

grafana模板id -> 7362


运行mysql exporter docker容器  
注意替换下面命令中的node_ip为本机ip，注意开放端口
```
docker run -d \
  --name mysql_exporter \
  --restart always \
  -p 9104:9104 \
  -e DATA_SOURCE_NAME="exporter:123456@(node_ip:3306)/" \
  prom/mysqld-exporter
```
执行后通过mode_ip:9104/metrics访问服务。prometheus监控外部服务的方式看internal.yaml