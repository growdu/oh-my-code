FROM centos:centos7.6.1810

MAINTAINER duanyingshou
RUN yum install wget -y \
&& mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo_bak \
&& wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
&& yum clean all \
&& yum makecache

RUN yum -y --nogpgcheck install gcc gcc-c++ kernel-devel make cmake  libstdc++-devel libstdc++-static glibc-devel glibc-headers \
&& yum -y --nogpgcheck install openssl-devel gperftools-libs \
&& yum -y --nogpgcheck install psmisc openssh-server sudo epel-release \
&& yum -y --nogpgcheck install vim git ctags net-tools tcpdump \
&& yum -y --nogpgcheck install protobuf-c protobuf-c-devel protobuf doxygen  java-1.8.0-openjdk java-1.8.0-openjdk-devel \
&& yum -y --nogpgcheck install bison flex readline readline-devel icu libicu-devel yacc libxml2-devel libxml2  \
&& yum -y --nogpgcheck install gdb unzip tar

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
        && sed -ri 's/UsePAM yes/#UsePAM no/g' /etc/ssh/sshd_config 
RUN useradd -m -s /bin/bash coder
RUN echo "coder:coder" | chpasswd
RUN echo "root:123" | chpasswd
RUN chmod 755 /etc/ssh/sshd_config \
&& ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
&& ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key \
&& ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key \
&& ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key

COPY  code-server-4.16.1-amd64.rpm /home/coder/
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN mkdir -p /home/coder/entrypoint.d
ENV ENTRYPOINTD=/home/coder/entrypoint.d

RUN rpm -ivh /home/coder/code-server-4.16.1-amd64.rpm

EXPOSE 8080
WORKDIR /home/coder
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]
