FROM centos:7
ENV container docker

RUN cd /var/tmp && \
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

RUN pip install boto boto3 ansible

RUN yum install -y epel-release \
                       sudo \
                       openssh \
                       openssh-server \
                       openssh-clients

RUN yum install -y jq

COPY . /terraform/

# Permissons
RUN chmod 400 /terraform/ansible/inventory/ssh_keys/id_rsa && \
    chmod 644 /terraform//ansible/inventory/ssh_keys/id_rsa.pub && \
    chmod 770 /terraform/*.sh

RUN cd /terraform/terraform && ./terraform init

WORKDIR /terraform

