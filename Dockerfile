FROM quay.io/apimatic/http-server-base:stable
WORKDIR /app
EXPOSE 9080
COPY portal.zip ./portal.zip

RUN unzip portal.zip -d ./output


ENTRYPOINT [ "http-server", "/app/output", "-p", "9080" ]
