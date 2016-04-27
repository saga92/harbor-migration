FROM mysql:latest

RUN sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y curl python python-pip git python-mysqldb

RUN pip install alembic

#RUN cd /home && git clone https://github.com/saga92/harbor-migration.git

WORKDIR /home/harbor-migration

COPY ./harbor-migration ./

COPY ./migration.cfg ./

RUN ./install.sh

ENTRYPOINT ["./run.sh"] 
