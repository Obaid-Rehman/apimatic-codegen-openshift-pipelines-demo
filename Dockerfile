FROM node:16-alpine
RUN mkdir -p /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app

RUN chgrp -R 0 /home/node/app && chmod -R g+rwX /home/node/app

RUN apk add -U unzip && rm -rf /var/cache/apk/*

COPY portal.zip portal.zip

RUN unzip portal.zip -d ./

RUN rm portal.zip

USER 1000

RUN npm install --local http-server

COPY --chown=node:node . /home/node/app

EXPOSE 9080

ENTRYPOINT [ "http-server", "./", "-p", "9080" ]
