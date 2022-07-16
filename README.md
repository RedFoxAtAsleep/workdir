```bash
sudo yum install -y java git expect tree maven ant

sudo apt-get update
sudo apt-get install -y tree default-jre default-jdk git expect maven ant
bash code/operator/bin/install-docker.sh
docker swarm init
docker stack deploy -c code/coupon/coupon.yml coupon
#docker stack ls
#docker stack ps coupon
#docker stack services coupon
#docker stack rm coupon
#http://1.13.2.185:8080  pgadmin    bbxxone@qq.com/Q1w2e3r4
#http://1.13.2.185:15672 rabbitmq   guest/guest
#1.13.2.185  15432  postgres    postgres/postgres
#1.13.2.185  16379  redis

#代码版本管理使用Git
#数据库对象版本管理使用Liquibase
#配置Docker、Maven等的镜像
#mvn spring-boot:run



```
