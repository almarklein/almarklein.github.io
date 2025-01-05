# mypaas.service = almarklein.org
#
# mypaas.url = https://almarklein.org
# mypaas.url = https://www.almarklein.org
# mypaas.url = https://almarklein.nl
# mypaas.url = https://www.almarklein.nl
#
# mypaas.scale = 0
#
# mypaas.maxmem = 100m

FROM python:3.10-slim-buster

RUN apt update \
    && pip --no-cache-dir install pip --upgrade \
    && pip --no-cache-dir install uvicorn uvloop httptools \
    && pip --no-cache-dir install markdown pygments asgineer>=0.8

WORKDIR /root
COPY . .
CMD ["python", "server.py"]
