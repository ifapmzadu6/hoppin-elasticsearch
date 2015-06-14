FROM ubuntu

RUN sudo apt-get update
RUN sudo apt-get install -y wget curl unzip

# install java7
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:webupd8team/java
RUN sudo apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN sudo apt-get install -y oracle-java7-installer

# install elasticsearch
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.5/debian stable main" | sudo tee -a /etc/apt/sources.list
RUN sudo apt-get update
RUN sudo apt-get install elasticsearch
RUN sudo service elasticsearch stop

# elasticsearch mysql driver
RUN wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.35.tar.gz
RUN tar xvfz mysql-connector-java-5.1.35.tar.gz
RUN sudo mv mysql-connector-java-5.1.35/mysql-connector-java-5.1.35-bin.jar /usr/share/java
ENV CLASSPATH=$CLASSPATH:/usr/share/java/mysql-connector-java-5.1.35-bin.jar

# install plugin
RUN sudo /usr/share/elasticsearch/bin/plugin --install jdbc --url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-river-jdbc/1.5.0.5/elasticsearch-river-jdbc-1.5.0.5-plugin.zip
RUN cp /usr/share/java/mysql-connector-java-5.1.35-bin.jar /usr/share/elasticsearch/plugins/jdbc/

EXPOSE 9200

CMD ["/usr/share/elasticsearch/bin/elasticsearch"]

