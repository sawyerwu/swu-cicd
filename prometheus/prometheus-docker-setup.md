docker pull prom/node-exporter
docker pull prom/prometheus
docker pull grafana/grafana

### node-exporter
```
docker run -d -p 9100:9100 \
  -v "/proc:/host/proc:ro" \
  -v "/sys:/host/sys:ro" \
  -v "/:/rootfs:ro" \
  --net="host" \
  prom/node-exporter
```

### prometheus
```
internal_ip=$(ifconfig eth0|grep inet | awk '{print $2}'| head -1)

mkdir /opt/prometheus
cd /opt/prometheus/
vim prometheus.yml

global:
  scrape_interval:     60s
  evaluation_interval: 60s
 
scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ['localhost:9090']
        labels:
          instance: prometheus
 
  - job_name: linux
    static_configs:
      - targets: ['192.168.91.132:9100']
        labels:
          instance: linux

docker run  -d \
  -p 9090:9090 \
  -v /opt/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml  \
  prom/prometheus
```

### grafana
```
mkdir /opt/grafana-storage
chmod 777 -R /opt/grafana-storage

docker run -d \
  -p 3000:3000 \
  --name=grafana \
  -v /opt/grafana-storage:/var/lib/grafana \
  grafana/grafana
```