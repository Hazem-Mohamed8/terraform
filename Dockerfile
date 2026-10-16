FROM jenkins/jenkins:lts

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends ansible sudo unzip \
    && rm -rf /var/lib/apt/lists/*

ARG TF_VERSION=1.10.5
RUN curl -fsSLO https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip -d /usr/local/bin \
    && rm terraform_${TF_VERSION}_linux_amd64.zip

# Lab only
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/jenkins \
    && chmod 440 /etc/sudoers.d/jenkins

USER jenkins