FROM mysql:5.6

RUN sed -i -e 's/us.archive.ubuntu.com/archive.ubuntu.com/g' /etc/apt/sources.list

RUN apt-get update

RUN apt-get install -y curl python python-pip git python-mysqldb

RUN pip install alembic

RUN mkdir -p /harbor-migration

WORKDIR /harbor-migration

COPY ./ ./

COPY ./migration.cfg ./

RUN ./install.sh

ENTRYPOINT ["./run.sh"] 
