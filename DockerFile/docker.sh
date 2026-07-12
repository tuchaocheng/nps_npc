
docker  rm -f nps

#client
#docker  run -itd --name=nps       \
#        --privileged=true         \
#        --network=host            \
#        --restart=always          \
#        -e service_type=npc     \
#        -e conn_nps_host=www.chengapp.asia         \
#        -e conn_nps_port=8024     \
#        -e conn_nps_vkey=123456   \
#        nps_npc:latest
#server
#docker  run -itd --name=nps       \
#        --privileged=true         \
#        --network=host            \
#        --restart=always          \
#        -e service_type=nps       \
#        -e nps_web_port=18080     \
#        -e nps_web_user=admin     \
#        -e nps_web_pass=admin     \
#        -e nps_web_host=192.168.10.19          \
#        -e nps_http_80=8000         \
#        -e nps_https_443=18443      \
#        -e nps_port=8024          \
#        -e nps_vkey=123456        \
#        nps_npc:latest
 
#docker  run -itd --name=nps       \
#        --privileged=true         \
#        --network=host            \
#        --restart=always          \
#        -e service_type=npc       \
#        -e conn_nps_host=www.chengapp.asia         \
#        -e conn_nps_port=8024     \
#        -e conn_nps_vkey=123456   \
#        -e nps_web_port=18080     \
#        -e nps_web_user=admin     \
#        -e nps_web_pass=admin     \
#        -e nps_web_host=          \
#        -e nps_http_80=8000         \
#        -e nps_https_443=18443      \
#        -e nps_port=8024          \
#        -e nps_vkey=123456        \
#        nps_npc:latest

#speed configure
docker  run -itd --name=nps               \
        --privileged=true                 \
        --network=host                    \
        --restart=always                  \
        -e service_type=npc               \
        -e service_host=www.chengapp.asia \
        -e service_vkey=123456            \
        -e service_nps_conn_port=8024     \
        -e service_http_port=18080        \
        -e service_https_port=18443       \
        -e service_web_user=admin         \
        -e service_web_pass=admin         \
        -e service_web_port=8080          \
        nps_npc:latest


