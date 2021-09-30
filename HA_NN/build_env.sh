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

ln -s /etc/hadoop-2.7.7 /etc/hadoop
ln -s /etc/zookeeper-3.4.6 /etc/zookeeper

echo "export JAVA_HOME=/usr/jdk1.8.0_191" >> /root/.bashrc
echo "export JRE_HOME=/usr/jdk1.8.0_191/jre" >> /root/.bashrc

echo "export HADOOP_HOME=/etc/hadoop" >> /root/.bashrc
echo "export ZOOKEEPER_HOME=/etc/zookeeper" >> /root/.bashrc

source /root/.bashrc

echo "export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /root/.bashrc
echo "export HADOOP_MAPRED_HOME=$HADOOP_HOME" >> /root/.bashrc
echo "export HADOOP_COMMON_HOME=$HADOOP_HOME" >> /root/.bashrc
echo "export YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop" >> /root/.bashrc

echo "export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$ZOOKEEPER_HOME/bin:$YARN_CONF_DIR/bin:$HADOOP_COMMON_HOME/bin:$HADOOP_CONF_DIR/bin:$HADOOP_MAPRED_HOME/bin" >> /root/.bashrc


source /root/.bashrc

update-alternatives --config java << 'EOF'
1
EOF


#######   Master Host only ----

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ''
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh/
chmod 600 ~/.ssh/*

-- Copy id_rsa.pub file to nn2
# test connection
ssh localhost  
ssh nn2.vanilla.hadoop

# ---NN1 Host---
1- hadoop-daemon.sh start journalnode
2- hdfs namenode -format
3- hadoop-daemon.sh start namenode
# -- NN2 Host ----
4- hdfs namenode -bootstrapStandby
5- hadoop-daemon.sh start namenode
6- zkServer.sh start
# ---NN1 Host---
7- zkServer.sh start
8- hadoop-daemon.sh start zkfc
# -- NN2 Host ----
9. hadoop-daemon.sh start zkfc

# -- NN1 Host ----
[root@nn1 hadoop]# jps
3635 JournalNode
3799 QuorumPeerMain
3691 NameNode
3851 DFSZKFailoverController
4205 Jps

# -- NN2 Host ----
[root@nn2 ~]# jps
18018 DFSZKFailoverController
17461 QuorumPeerMain
18198 DataNode
18267 Jps
18093 NameNode


[root@nn1 hadoop]# hdfs haadmin -getServiceState nn1
active
[root@nn1 hadoop]# hdfs haadmin -getServiceState nn2
standby
