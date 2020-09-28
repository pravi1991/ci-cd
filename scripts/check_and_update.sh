#!/bin/bash

# Resources name
# elastic='elasticsearch-master'
# kibana='kibana'
# filebeat='filebeat'
# logstash='filebeat-logstash'

# # Resources Type
# type_elastic='sts'
# type_kibana='deploy'
# type_filebeat='ds'
# type_logstash='sts'

# Configmap file names
res_elastic='elasticsearh.yaml'
res_kibana='kibana.yaml'
res_logstash='logstash.yaml'
res_filebeats='filebeat.yaml'

# Configmap file names
cm_elastic='elasticsearh.config.yaml'
cm_kibana='kibana.config.yaml'
cm_logstash='logstash.config.yaml'
cm_filebeats='filebeat.config.yaml'

# Resource labels
label_elastic=' elasticsearch-logging'
label_kibana=' kibana'
label_filebeat='filebeat'
label_logstash='logstash'

# check for resource status
kubectl apply -f k8s-manifests/

for item in $(git diff-tree --no-commit-id --name-only -r `git rev-parse HEAD`); do
    if [ $cm_elastic == $item ]; then 
        kubectl apply -f $cm_elastic -f $res_elastic
        kubectl rollout restart sts/elasticsearch-master 
        kubectl rollout status sts/elasticsearch-master
    else 
        kubectl apply -f $cm_elastic -f $res_elastic
    fi
    if [ $cm_kibana == $item ]; then 
        kubectl apply -f $cm_kibana -f $res_kibana
        kubectl rollout restart deploy/kibana
        kubectl rollout status deploy/kibana
    else 
        kubectl apply -f $cm_kibana -f $res_kibana
    fi
    if [ $cm_filebeat == $item ]; then 
        kubectl apply -f $cm_filebeat -f $res_filebeat
        kubectl rollout restart ds/filebeat
        kubectl rollout status ds/filebeat
    else
        kubectl apply -f $cm_filebeat -f $res_filebeat
    fi
    if [ $cm_logstash == $item ]; then 
        kubectl apply -f $cm_logstash -f $res_logstash
        kubectl rollout restart ds/filebeat-logstash
        kubectl rollout status ds/filebeat-logstash
    else
        kubectl apply -f $cm_logstash -f $res_logstash
    fi
done

    
    

