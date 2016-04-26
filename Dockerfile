FROM mysql:latest

RUN sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y curl python python-pip git python-mysqldb

RUN pip install alembic

RUN cd /home && git clone https://github.com/saga92/harbor-migration.git

COPY ./harbor-migration /home/harbor-migration

COPY ./migration.cfg /home/harbor-migration/

RUN /home/harbor-migration/install.sh

ENTRYPOINT ["/home/harbor-migration/run.sh"] 
