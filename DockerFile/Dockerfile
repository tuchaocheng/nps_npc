FROM alpine:latest


LABEL author="docker  run -itd --name=nps   --privileged=true    --network=host     --restart=always   -e service_type=npc    -e service_host=www.chengapp.asia -e service_vkey=123456   -e service_nps_conn_port=8024 -e service_http_port=18080  -e service_https_port=18443  -e service_web_user=admin  -e service_web_pass=admin    -e service_web_port=8080  nps_npc:latest"
EXPOSE 80/tcp 
EXPOSE 8080/tcp 
EXPOSE 443/tcp
WORKDIR /app
RUN     mkdir /app/npc  /app/nps  && \
        apk add bash net-tools && \
        rm -rf /bin/sh  && ln -s /bin/bash /bin/sh 

# 下载0.26.10 linux amd64二进制
#RUN wget https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_server.tar.gz \
#    && tar -zxvf linux_amd64_server.tar.gz \
#    && mv linux_amd64_server/nps /app/nps \
#    && rm -rf linux_amd64_server linux_amd64_server.tar.gz
#
#RUN wget https://github.com/ehang-io/nps/releases/download/v0.26.10/linux_amd64_client.tar.gz \
#    && tar -zxvf linux_amd64_client.tar.gz \
#    && mv linux_amd64_client/npc /app/npc \
#    && rm -rf linux_amd64_client linux_amd64_client.tar.gz


ADD linux_amd64_server.tar.gz  /app/nps
ADD linux_amd64_client.tar.gz  /app/npc

COPY nps.conf /app/nps/conf/nps.conf
COPY npc.conf /app/npc/conf/npc.conf
COPY entrypoint.sh  /entrypoint.sh  



ENTRYPOINT ["/entrypoint.sh"]

