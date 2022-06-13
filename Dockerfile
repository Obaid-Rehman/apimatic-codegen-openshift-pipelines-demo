FROM quay.io/apimatic/http-server-base
WORKDIR /app
EXPOSE 9080
USER 1000

COPY portal.zip ./portal.zip

RUN unzip portal.zip -d ./output

ENTRYPOINT [ "http-server", "/app/output", "-p", "9080" ]
