FROM minio/minio:latest

COPY server/services/minio/Script.sh Script.sh
RUN chmod +x Script.sh

CMD [ "sh", "Script.sh" ]

EXPOSE 9000
EXPOSE 9001