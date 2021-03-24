FROM  openjdk:11-jre

WORKDIR /app

COPY ./keyvaultdemo-1.0.0.RELEASE.jar /app/keyvaultdemo-1.0.0.RELEASE.jar

ENV SERVER_PORT="8080"

CMD [ "java","-jar","/app/keyvaultdemo-1.0.0.RELEASE.jar"]