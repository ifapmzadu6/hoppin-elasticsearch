FROM ubuntu

RUN sudo apt-get update
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:webupd8team/java
RUN sudo apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN sudo apt-get install -y oracle-java7-installer
RUN sudo apt-get install -y wget curl unzip

RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.5/debian stable main" | sudo tee -a /etc/apt/sources.list

RUN sudo apt-get update
RUN sudo apt-get install elasticsearch

RUN sudo service elasticsearch stop

RUN wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz
RUN tar xvfz mysql-connector-java-5.1.35.tar.gz
RUN sudo mv mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar /usr/share/java
ENV CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java-5.1.35-bin.jar

RUN wget http://xbib.org/repository/org/xbib/elasticsearch/importer/elasticsearch-jdbc/1.6.0.0/elasticsearch-jdbc-1.6.0.0-dist.zip
RUN unzip elasticsearch-jdbc-1.6.0.0-dist.zip
RUN mv elasticsearch-jdbc-1.6.0.0/lib/mysql-connector-java-5.1.33.jar /usr/share/elasticsearch/plugins/


EXPOSE 9200

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]

