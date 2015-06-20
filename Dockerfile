FROM sequenceiq/hadoop-docker:2.6.0
MAINTAINER Neil Rubens

# NR: spark installation modified for scala 2.11 
# based on: https://spark.apache.org/docs/latest/building-spark.html#building-for-scala-211

# NR: install maven
# based on: https://gist.github.com/sebsto/19b99f1fa1f32cae5d00
RUN yum install -y wget
RUN wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
RUN sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
RUN yum install -y apache-maven

# NR: download source code so can build it for 2.11
#RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.4.0-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.4.0.tgz | tar -xz -C /usr/local/
# build for scala 2.11 and hadoop 2.6
RUN export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
RUN /usr/local/spark-1.4.0/dev/change-version-to-2.11.sh



# build and make distributable/runnable spark: https://spark.apache.org/docs/latest/building-spark.html#building-a-runnable-distribution
# TODO-UPGRADE: when upgrading spark need to double-check the lines that are being deleted bellow
# delete lines that require user input (asking if it is ok to proceed): e.g.:
#  read -p "Would you like to continue anyways? [y,n]: " -r
#  if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
RUN sed -i.bak -e '153,157d' /usr/local/spark-1.4.0/make-distribution.sh
#RUN cat /usr/local/spark-1.4.0/make-distribution.sh

#RUN cd /usr/local/spark-1.4.0/ && ./make-distribution.sh --name custom  -Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.0 -DskipTests -Dscala-2.11 package clean
RUN cd /usr/local/spark-1.4.0/ && ./build/mvn -Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.0 -DskipTests -Dscala-2.11 clean package
RUN cd /usr/local/ && ln -s spark-1.4.0 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client

RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-1.4.0/lib /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENTRYPOINT ["/etc/bootstrap.sh"]
