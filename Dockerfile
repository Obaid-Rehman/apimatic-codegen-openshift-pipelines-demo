FROM node:16-alpine
WORKDIR /app
EXPOSE 9080

ENV NODE_ENV=production \
    NPM_CONFIG_PREFIX=/home/node/.npm-global \
    PATH=$PATH:/home/node/.npm-global/bin:/home/node/node_modules/.bin

COPY portal.zip portal.zip

RUN unzip portal.zip -d ./ && rm portal.zip

RUN npm install --location=global http-server

RUN chown -R 1001:0 /app && chmod -R ug+rwx /app

USER 1001

ENTRYPOINT [ "http-server", "./", "-p", "9080" ]
