# Helm Chart: Sophora Indexing Service

## Related Helm charts

The Solr Helm Chart is in a weird state of not really being officially supported and currently being adopted 
by one of the members (see [this Github comment](https://github.com/helm/charts/issues/23685)).

* [preferred-ai/solr (Solr + Zookeeper)](https://github.com/PreferredAI/helm-charts)
* [bitnami/redis](https://bitnami.com/stack/redis/helm)

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
            codec: !<com.subshell.sophora.indexingservice.dataaccess.queue.redis.BetterJacksonCodec> {}

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
    memory: "0.5G"
    cpu: "0.25"
  limits:
    memory: "2G"
    cpu: "1"
```