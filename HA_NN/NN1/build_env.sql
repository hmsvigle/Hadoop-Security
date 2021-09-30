#!/bin/bash
# Apache vanilla cluster
#service network start/stop/restart
# -----  update /etc/hosts file of all servers to enable reverse DNS naming.

yum -y update && yum install -y wget

wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
tar -xzvf zookeeper-3.4.6.tar.gz -C /etc

wget https://archive.apache.org/dist/hadoop/core/hadoop-2.7.7/hadoop-2.7.7.tar.gz
tar -xzvf hadoop-2.7.7.tar.gz -C /etc

wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/jdk-8u191-linux-x64.tar.gz
# mkdir -p /usr/java/default
tar -xzvf jdk-8u191-linux-x64.tar.gz -C /usr/
update-alternatives --install /usr/bin/java java /usr/jdk1.8.*/bin/java 2
update-alternatives --config java
	1

ln -s /etc/hadoop-2.7.7 /etc/hadoop
ln -s /etc/zookeeper-3.4.6 /etc/zookeeper

echo "export JAVA_HOME=/usr/jdk1.8.0_191" >> /root/.bashrc
echo "export JRE_HOME=/usr/jdk1.8.0_191/jre" >> /root/.bashrc
echo "export J2SDKDIR=/usr/jdk1.8.0_191" >> /root/.bashrc
echo "export J2REDIR=/usr/jdk1.8.0_191/jre" >> /root/.bashrc

echo "export HADOOP_HOME=/etc/hadoop" >> /root/.bashrc
echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /root/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> /root/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> /root/.bashrc
echo "export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /root/.bashrc

echo "export ZOOKEEPER_HOME=/etc/zookeeper" >> /root/.bashrc
echo "export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$ZOOKEEPER_HOME/bin" >> /root/.bashrc
echo "export PATH=$PATH:$YARN_CONF_DIR/bin:$HADOOP_COMMON_HOME/bin:$HADOOP_CONF_DIR/bin:$HADOOP_MAPRED_HOME/bin" >> /root/.bashrc

#######   Master Host only ----

ssh-keygen -t rsa
----
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/*
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys