#!/usr/bin/env bash
set -e
# enable debug mode if desired
if [[ "${DEBUG}" == "true" ]]; then
    set -x
    #sleep 3333333
fi

#service_nps
nps_http_port=${nps_http_80:-80}
nps_https_port=${nps_https_443:-443}
nps_web_host=$nps_web_host
nps_web_user=${nps_web_user:-admin}
nps_web_password=${nps_web_pass:-admin}
nps_web_port=${nps_web_port:-8080}
nps_server_vkey=${nps_vkey:-123456}
nps_server_port=${nps_port:-8024}
nps_conf=

#service_npc
nps_conn_port=${conn_nps_port:-8024}
nps_conn_vkey=${conn_nps_vkey:-123456}
nps_conn_host=$conn_nps_host
nps_conn_conf=


#all_set
#service_type=${service_type:-npc}
#service_host=$nps_conn_host
#service_vkey=${nps_vkey:-123456}
#service_nps_conn_port=${nps_port:-8024}

#############################
    
    nps_start(){  

        service_host=${service_host:-$nps_web_host}
        service_vkey=${service_vkey:-$nps_vkey}
        service_nps_conn_port=${service_nps_conn_port:-$nps_port}
        service_http_port=${service_http_port:-$nps_http_port}
        service_https_port=${service_https_port:-$nps_https_port}
        service_web_user=${service_web_user:-$nps_web_user}
        service_web_pass=${service_web_pass:-$nps_web_password}
        service_web_port=${service_web_port:-$nps_web_port}
       sleep 2
       cat >/app/nps/conf/nps.conf << EOF
appname = nps
runmode = dev

#HTTP(S) proxy port, no startup if empty
http_proxy_ip=0.0.0.0
http_proxy_port=$service_http_port
https_proxy_port=$service_https_port
https_just_proxy=true
#default https certificate setting
https_default_cert_file=conf/server.pem
https_default_key_file=conf/server.key

##bridge
bridge_type=tcp
bridge_port=$service_nps_conn_port
bridge_ip=0.0.0.0

# Public password, which clients can use to connect to the server
# After the connection, the server will be able to open relevant ports and parse related domain names according to its own configuration file.
public_vkey=$service_vkey
vkey=$service_vkey

#Traffic data persistence interval(minute)
#Ignorance means no persistence
#flow_store_interval=1

# log level LevelEmergency->0  LevelAlert->1 LevelCritical->2 LevelError->3 LevelWarning->4 LevelNotice->5 LevelInformational->6 LevelDebug->7
log_level=7
log_path=nps.log

#Whether to restrict IP access, true or false or ignore
#ip_limit=true

#p2p
#p2p_ip=127.0.0.1
#p2p_port=6000

#web
web_host=$service_host
web_username=$service_web_user
web_password=$service_web_pass
web_port =$service_web_port
web_ip=0.0.0.0
web_base_url=
web_open_ssl=false
web_cert_file=conf/server.pem
web_key_file=conf/server.key
# if web under proxy use sub path. like http://host/nps need this.
#web_base_url=/nps

#Web API unauthenticated IP address(the len of auth_crypt_key must be 16)
#Remove comments if needed
#auth_key=test
auth_crypt_key =$service_vkey

#allow_ports=9001-9009,10001,11000-12000

#Web management multi-user login
allow_user_login=false
allow_user_register=false
allow_user_change_username=false


#extension
allow_flow_limit=false
allow_rate_limit=false
allow_tunnel_num_limit=false
allow_local_proxy=false
allow_connection_num_limit=false
allow_multi_ip=false
system_info_display=false

#cache
http_cache=false
http_cache_length=100

#get origin ip
http_add_origin_header=false

#pprof debug options
#pprof_ip=0.0.0.0
#pprof_port=9999

#client disconnect timeout
disconnect_timeout=60

EOF

       cd /app/nps/   &&  bash -c ./nps 

    } 

   
    npc_start(){
        service_host=${service_host:-$nps_conn_host}
        service_vkey=${service_vkey:-$nps_conn_vkey}
        service_nps_conn_port=${service_nps_conn_port:-$nps_conn_port}
        service_web_user=${nps_web_user:-admin}
        service_web_pass=${nps_web_password:-admin}
       sleep 2
       cat >/app/npc/conf/npc.conf << EOF
[common]
server_addr=$service_host:$service_nps_conn_port
conn_type=tcp
vkey=$service_vkey
auto_reconnection=true
max_conn=1000
flow_limit=1000
rate_limit=1000
basic_username=11
basic_password=3
web_username=$service_web_user
web_password=$service_web_pass
crypt=true
compress=true
#pprof_addr=0.0.0.0:9999
disconnect_timeout=60
EOF
       cd /app/npc/   &&  bash -c ./npc  

    }

    usage(){   
       cat  <<EOF
#client
docker  run -itd --name=nps       \
        --privileged=true         \
        --network=host            \
        --restart=always          \
        -e service_type=npc       \
        -e conn_nps_host=www.abc.com         \
        -e conn_nps_port=8024     \
        -e conn_nps_vkey=123456   \
        镜像名称:版本


#server
docker  run -itd --name=nps       \
        --privileged=true         \
        --network=host            \
        --restart=always          \
        -e service_type=nps       \
        -e nps_web_port=8080      \
        -e nps_web_user=admin     \
        -e nps_web_pass=admin     \
        -e nps_web_host=1.2.3.4   \
        -e nps_http_80=80         \
        -e nps_https_443=443      \
        -e nps_port=8024          \
        -e nps_vkey=123456        \
        镜像名称:版本


#speed configure(服务端和客户端保持一致,以下每个变量必须填写)
#客户端和服务端直接运行以下命令即可
docker  run -itd --name=nps            \
        --privileged=true              \
        --network=host                 \
        --restart=always               \
        -e service_type=nps            \ 
        -e service_host=1.2.3.4        \
        -e service_vkey=123456         \
        -e service_nps_conn_port=8024  \
        -e service_http_port=80        \
        -e service_https_port=443      \
        -e service_web_user=admin      \
        -e service_web_pass=admin      \
        -e service_web_port=8080       \
        镜像名称:版本


EOF

 
    }

##########################################################
#字体颜色
red="\033[31m"       #红色
gree="\033[32m"      #绿色
yellow="\033[33m"    #黄色
blue="\033[34m"    #蓝色
purple="\033[35m"    #紫色
Cyan="\033[36m"      #青色
white="\033[37m"     #白色
colourless="\033[0m" #无色
ERROR="${red}[错误]${colourless}"
INFO="${gree}[信息]${colourless}"
WRINNING="${yellow}[注意]${colourless}"
RED="${red}###${colourless}"
default_ks_color="${gree}default.ks${colourless}"
#########################################################
  #sleep 88888
  if [[ $service_type == "nps" ]];then
    echo -e $INFO "将作为${gree} NPS ${colourless}服务端去加载服务"
    nps_start
    
  elif [[ $service_type == "npc" ]];then
    echo -e $INFO "将作为${gree} NPC ${colourless}客户端去连接NPS服务器"
    npc_start
  elif [[ $service_type == "help" ]];then
    usage
  else
    usage
  fi


