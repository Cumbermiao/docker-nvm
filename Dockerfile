FROM ubuntu:20.04
# ubuntu 18.04 版本不满足 GLIBC 2.28版本要求，会导致 node 指标报错
LABEL version="0.1"
LABEL author="cumbermiao@163.com"
ENV NVM_NODEJS_ORG_MIRROR https://npmmirror.com/mirrors/node/

# 安装依赖 ssh 配置
RUN apt-get update && apt-get install -y openssh-server curl
RUN /usr/sbin/sshd -D &
RUN mkdir -p /var/run/sshd
RUN echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN touch /root/.ssh/authorized_keys
ADD rsa.pub /root/.ssh/
RUN cat /root/.ssh/rsa.pub >> /root/.ssh/authorized_keys
ADD run.sh /run.sh
RUN chmod 755 /run.sh
EXPOSE 22

# nvm 安装
RUN curl -o- https://gitee.com/mirrors/nvm/raw/v0.39.7/install.sh | bash
RUN bash -c "source ~/.bashrc" 

CMD [ "/run.sh" ]
