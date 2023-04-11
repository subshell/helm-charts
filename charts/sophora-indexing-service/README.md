# Sophora Indexing Service

The Sophora Indexing Service reads all Sophora documents and indexes them in SolrCloud.

## Dependencies and SolrCloud

* [bitnami/redis](https://bitnami.com/stack/redis/helm)
* [bitnami/solr](https://bitnami.com/stack/solr/helm)

## Example 

```yaml
image:
  pullPolicy: Always
  tag: "latest"

imagePullSecrets:
  - name: docker-subshell

solr:
  basicAuth:
    enabled: true
    secret:
      name: solr-admin-credentials

sophora:
  authentication:
    secret:
      name: sophora-user-admin-credentials

redis:
  authentication:
    secret:
      name: redis-admin-credentials

sisi:
  configuration:
    spring:
      application:
        name: Sophora Indexing Service 👑
      jmx:
        enabled: false
      redis:
        redisson:
          config: |-
            sentinelServersConfig:
                password: ${REDIS_AUTHENTICATION_PASSWORD}
                masterName: "redis-master"
                sentinelAddresses:
                - "redis://redis-node-0.redis-headless.sophora:26379"
                - "redis://redis-node-1.redis-headless.sophora:26379"
            codec: !<com.subshell.sophora.indexingservice.core.codec.SISIJsonJacksonCodec> {}

    sophora:
      solr:
        # see https://lucene.472066.n3.nabble.com/How-to-resolve-a-single-domain-name-to-multiple-zookeeper-IP-in-Solr-td4450236.html#a4450301
        zk-hosts:
          - solr-zookeeper-headless.sophora
          - solr-zookeeper-headless.sophora

      client:
        server-connection:
          urls:
            - "http://my-server:1196"

    logging:
      level:
        root: INFO

resources:
  requests:
    memory: "2G"
    cpu: "0.25"
  limits:
    memory: "2G"
```
