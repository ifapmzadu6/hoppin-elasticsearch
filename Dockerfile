FROM ubuntu

RUN sudo apt-get update
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y wget curl unzip

# install java7
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:webupd8team/java
RUN sudo apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN sudo apt-get install -y oracle-java8-installer
RUN sudo apt-get install -y oracle-java8-set-default

# install elasticsearch
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.7/debian stable main" | sudo tee -a /etc/apt/sources.list
RUN sudo apt-get update
RUN sudo apt-get install -y elasticsearch 
RUN sudo service elasticsearch stop

RUN sudo mkdir /usr/share/elasticsearch/config
RUN sudo ln -s /etc/elasticsearch/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
RUN sudo ln -s /etc/elasticsearch/logging.yml /usr/share/elasticsearch/config/logging.yml

# install plugins
RUN sudo /usr/share/elasticsearch/bin/plugin --install mobz/elasticsearch-head
RUN sudo /usr/share/elasticsearch/bin/plugin --install royrusso/elasticsearch-HQ

# install JDBC
WORKDIR /root
RUN wget --no-verbose http://xbib.org/repository/org/xbib/elasticsearch/importer/elasticsearch-jdbc/1.7.0.1/elasticsearch-jdbc-1.7.0.1-dist.zip
RUN unzip elasticsearch-jdbc-1.7.0.1-dist.zip
ENV JDBC_IMPORTER_HOME=/root/elasticsearch-jdbc-1.7.0.1

# install kibana
RUN wget --no-verbose https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
RUN tar zxvf kibana-4.1.1-linux-x64.tar.gz

# launch
ADD ./start.sh /root/start.sh
ADD ./add.sh /root/add.sh
ADD ./kibana.sh ./kibana.sh
RUN chmod +x /root/start.sh
RUN chmod +x /root/add.sh
RUN chmod +x /root/kibana.sh

EXPOSE 9200
EXPOSE 5601

WORKDIR /

CMD [ "/root/start.sh" ]

