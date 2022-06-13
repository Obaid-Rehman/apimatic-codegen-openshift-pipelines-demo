FROM quay.io/apimatic/http-server-base
WORKDIR /app
EXPOSE 9080
USER 1000

COPY portal.zip ./portal.zip

RUN unzip portal.zip -d ./

ENTRYPOINT [ "http-server", "/app", "-p", "9080" ]
