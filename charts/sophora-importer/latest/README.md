# Helm Chart: Sophora Importer

## Dockerfile for additional importer data (libs, xsl files, ...)

Setting up a docker image with additional importer libraries and xsl files required by the Sophora importer.
The saxon licence can be part of the `data/libs` directory but preferably should be provided as a k8s secret.
Supported directories are:

* `data/libs`
* `data/xsl`
* (`data/misc` for additional content required by the transformations)

### Dockerfile

    FROM alpine:latest
    
    LABEL maintainer="osc"
    
    WORKDIR /data
    
    ARG ARTIFACTORY_USR
    ARG ARTIFACTORY_PWD
    
    RUN apk update \                                                                                                                                                                                                                        
    && apk add ca-certificates wget unzip \                                                                                                                                                                                                      
    && update-ca-certificates
    
    # XSL
    RUN wget --user ${ARTIFACTORY_USR} --password ${ARTIFACTORY_PWD} -O /tmp/migration-xsl.zip https://software.subshell.com/unified-sophora/xsl/migration-xsl.zip \
    && mkdir /data/xsl \
    && unzip /tmp/migration-xsl.zip -d /data/xsl
    
    # Libs
    ADD libs /data/libs
