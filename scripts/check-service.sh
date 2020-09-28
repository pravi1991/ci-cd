#!/bin/bash

# Resources name
elastic='elasticsearch-master'
kibana='kibana'
filebeat='filebeat'
logstash='filebeat-logstash'

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

for item in $(git diff-tree --no-commit-id --name-only -r `git rev-parse HEAD`); do
    if [ $cm_elastic == $item ]; then 
            
