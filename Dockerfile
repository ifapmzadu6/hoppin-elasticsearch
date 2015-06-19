FROM ubuntu

RUN sudo apt-get update
RUN sudo apt-get upgrade -y
RUN sudo apt-get install -y wget curl unzip

# install java7
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository ppa:webupd8team/java
RUN sudo apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN sudo apt-get install -y oracle-java7-installer
RUN sudo apt-get install -y oracle-java7-set-default

# install elasticsearch
RUN wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
RUN echo "deb http://packages.elasticsearch.org/elasticsearch/1.6/debian stable main" | sudo tee -a /etc/apt/sources.list
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
WORKDIR /usr/share/elasticsearch/plugins
RUN wget --no-verbose http://xbib.org/repository/org/xbib/elasticsearch/importer/elasticsearch-jdbc/1.6.0.0/elasticsearch-jdbc-1.6.0.0-dist.zip
RUN unzip elasticsearch-jdbc-1.6.0.0-dist.zip
ENV JDBC_IMPORTER_HOME=/usr/share/elasticsearch/plugins/elasticsearch-jdbc-1.6.0.0
WORKDIR /

# launch
ADD ./start.sh ./start.sh
ADD ./add.sh ./add.sh
RUN chmod +x ./start.sh
RUN chmod +x ./add.sh

EXPOSE 9200

CMD [ "./start.sh" ]

