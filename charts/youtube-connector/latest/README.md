# Helm Chart: youtube-connector

This chart deploys youtube-connector.

## What you need (requirements)

This chart requires the following already present in the target namespace:

* An ImagePullSecret for the subshell Docker Registry
* A secret containing username and password for the sophora server.

## Example values.yaml

```yaml
image:
  repository: docker.subshell.com/daserste/youtube-connector
  pullPolicy: IfNotPresent
  # Overrides the image tag whose default is the chart appVersion.
  tag: "3.0.1"

javaOptions: "-XX:MinRAMPercentage=50.0 -XX:MaxRAMPercentage=90.0 -XX:+AlwaysPreTouch"

configGenerator:
  image:
    repository: "docker.subshell.com/misc/alpine-toolkit"
    tag: "0.0.1"
    pullPolicy: IfNotPresent

service:
  clusterIP: None
  port: 1496
  targetPort: 1496

resources:
  requests:
    memory: "3G"
    cpu: "0.5"
  limits:
    memory: "3.5G"
    cpu: "2"

sophora:
  youtubeconnector:
    logback: |
      <?xml version="1.0" encoding="UTF-8"?>
      <configuration scan="true" scanPeriod="60 seconds">
      <jmxConfigurator/>

      <!-- Propagate level settings to java.util.logging. -->
      <contextListener class="ch.qos.logback.classic.jul.LevelChangePropagator"/>

      <appender class="ch.qos.logback.core.rolling.RollingFileAppender" name="logfile">
      <File>logs/youtube-connector.log</File>
      <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>logs/youtube-connector.%d{yyyy-MM-dd}.log</fileNamePattern>
      <maxHistory>14</maxHistory>
      </rollingPolicy>
      <encoder>
      <pattern>[%d{"yyyy-MM-dd HH:mm:ss.SSSX",UTC}, %-5p] [%t] [UUID: %X{uuid}] [SOPHORA_ID: %X{sophora_id}] [USER: %X{user}] %c:%L: %m%n</pattern>
      </encoder>
      </appender>

      <appender class="ch.qos.logback.core.rolling.RollingFileAppender" name="errorLog">
      <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
      <level>ERROR</level>
      </filter>
      <File>logs/youtube-connector_error.log</File>
      <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
      <fileNamePattern>logs/youtube-connector_error.%d{yyyy-MM-dd}.log</fileNamePattern>
      <maxHistory>14</maxHistory>
      </rollingPolicy>
      <encoder>
      <pattern>[%d{"yyyy-MM-dd HH:mm:ss.SSSX",UTC}, %-5p] [%t] [UUID: %X{uuid}] [SOPHORA_ID: %X{sophora_id}] [USER: %X{user}] %c:%L: %m%n</pattern>
      </encoder>
      </appender>

      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
      <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
      <level>INFO</level>
      </filter>
      <filter class="ch.qos.logback.classic.filter.LevelFilter">
      <level>ERROR</level>
      <onMatch>DENY</onMatch>
      <onMismatch>ACCEPT</onMismatch>
      </filter>
      <encoder>
      <pattern>[%d{"yyyy-MM-dd HH:mm:ss.SSSX",UTC}, %-5p] [%t] [UUID: %X{uuid}] [SOPHORA_ID: %X{sophora_id}] [USER: %X{user}] %m%n</pattern>
      </encoder>
      </appender>

      <appender name="STDERR" class="ch.qos.logback.core.ConsoleAppender">
      <target>System.err</target>
      <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
      <level>ERROR</level>
      </filter>
      <encoder>
      <pattern>[%d{"yyyy-MM-dd HH:mm:ss.SSSX",UTC}, %-5p] [%t] [UUID: %X{uuid}] [SOPHORA_ID: %X{sophora_id}] [USER: %X{user}] %c:%L: %m%n</pattern>
      </encoder>
      </appender>

      <logger name="com.subshell.sophora" level="INFO" />
      <logger name="com.subshell.sophora.avtool" level="INFO" />
      <logger name="com.subshell.sophora.avtool.youtube" level="INFO" />
      <logger name="sun.rmi" level="WARN" />
      <logger name="com.google" level="INFO" />

      <root level="WARN">
      <appender-ref ref="STDOUT" />
      <appender-ref ref="STDERR" />
      <appender-ref ref="logfile"/>
      <appender-ref ref="errorLog"/>
      </root>
      </configuration>

    mediaconfig: |
      <?xml version="1.0" encoding="UTF-8"?>
      <beans xmlns="http://www.springframework.org/schema/beans" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:util="http://www.springframework.org/schema/util"
      xsi:schemaLocation="http://www.springframework.org/schema/beans
      http://www.springframework.org/schema/beans/spring-beans.xsd
      http://www.springframework.org/schema/util http://www.springframework.org/schema/util/spring-util.xsd">

      <!-- List of document types -->
      <util:list id="documentDescriptionList">
      <!-- Video -->
      <bean class="com.subshell.sophora.avtool.api.MediaDocumentDescription">
      <property name="formats">
      <set>
      <value>youtube</value>
      </set>
      </property>
      <!-- Only events for this document type are handled. -->
      <property name="nodeTypeName" value="example-nt:video" />
      </bean>
      </util:list>

      <!-- Feedback to DeskClient. Map: error type to error string (you can use a select value for readable labels). -->
      <util:map id="deskclientFeedbackErrTypeConf">
      <entry key="TRANSPORT_MEDIASERVER" value="transport_mediaserver" />
      <entry key="YOUTUBE" value="youtube" />
      <entry key="OTHER" value="other" />
      <entry key="MANY" value="many" />
      <entry key="OK" value="ok" />
      </util:map>

      <bean id="localTransporter" class="com.subshell.sophora.avtool.transporter.LocalFSTransporterFactory" />

      <bean id="mediaServerDescription" class="com.subshell.sophora.avtool.api.ServerDescription">
      <!-- Server name from which the video files should be retrieved. When local file transfer is used,
      this field is only used for logging. -->
      <property name="host" value="mediaserver" />
      <property name="basedir" value="src/test/resources/mediasource" />
      <property name="transporterFactory" ref="localTransporter" />
      <property name="formatDirectoryMapping">
      <map>
      <entry key="youtube" value="." />
      </map>
      </property>
      <property name="concatVideosScript" value="/opt/addOpenerCloser.sh" />
      </bean>

      <util:list id="streamingServerDescriptionList">

      <bean class="com.subshell.sophora.avtool.api.AkamaiServerDescription">

      <property name="name" value="video-cdn" />
      <property name="transporterFactory" ref="sftpTransporterFactory" />
      <property name="host" value="akamai.example.net" />
      <property name="port" value="22" />
      <property name="user" value="alice" />
      <property name="password" value="secret" />
      <property name="keyfile" value="" />

      <!-- Base directory for all uploads -->
      <property name="basedir" value="/video" />

      <!-- Akamai FastPurge -->
      <property name="akamaiUrlPrefixes">
      <list>
      <value>http://download.mysite.com/video/%1$tY/%1$tm%1$td/{filename}</value>
      <value>http://media.mysite.com/video/%1$tY/%1$tm%1$td/{filename}</value>
      </list>
      </property>

      <!-- Akamai HLS/HDS Purge   -->
      <property name="akamaiRestPurgeConfiguration">
      <list>
      <bean class="com.subshell.sophora.avtool.api.AkamaiRestPurgeRequestConfiguration">
      <property name="requestName" value="HLS" />
      <property name="requestPath" value="/config-media-live/v1/vod/purge/HLS"/>
      <property name="manifestUrl" value="https://mysite.akamaihd.net/i/video/%1$tY/%1$tm%1$td/{sequencename}.,webs,webm,webl,webxl,.h264.mp4.csmil/master.m3u8" />
      <property name="fileNamePattern" value="%1$tY/%1$tm%1$td/{filename}" />
      </bean>
      </list>
      </property>

      <!-- Mapping of format to server path. Can use date fields parsed using the dateRegex. -->
      <property name="formatDirectoryMapping">
      <map>
      <entry key="youtube" value="%1$tY/%1$tm%1$td" />
      </map>
      </property>
      </bean>
      </util:list>
      
      <!-- YouTube settings for all channels -->
      <bean id="youtubeGlobalConfig" class="com.subshell.sophora.avtool.api.youtube.YoutubeConfiguration">
      <!-- After uploading a video to YouTube, the YouTube id is written back to the document into this property.
      Required for removing videos from YouTube when the document goes offline. -->
      <property name="youtubeIdPropertyName" value="example:youtubeId" />
      <!-- Property of the document that indicates which channel to use. -->
      <property name="youtubeAccountPropertyName" value="youtube.channel" />
      <!-- The YouTube action to take when a video document is deleted or set offline. Options are DELETE, SET_PRIVATE, and DO_NOTHING. -->
      <property name="deleteEventAction" value="DELETE" />
      <property name="offlineEventAction" value="SET_PRIVATE" />
      <!-- Application for adding opener and closer to the beginning/end of video. The specific videos are configured per channel. -->
      <property name="concatVideosScript" value="/cms-install-directory/ytc_opener_und_closer/addOpenerCloser_ffmpeg.sh" />
      </bean>

      </beans>

    config: |
      sophoraServer.host = http://localhost:1196
      sophoraServer.username = youtubeconnector
      sophoraServer.password = XXXXXXX

      mediaConfig = file:config/mediaconfig.xml

      server.port = 5063

      jmx.registry.port = 5060
      rmi.registry.port = 5061
      jmx.registry.username =
      jmx.registry.password =

     youtube.chunking = true

      uploader.retry.count = 2
      uploader.retry.waitSeconds = 15

      digest.dir = /cms-install-directory/youtube-connector/digest

      job.store.path = /cms-install-directory/youtube-connector/queue.xml

      logonly.fileoperations = false
      logonly.publishdocuments = false

      tagging.propertyPrefix.regexp = ^(example:|sophora:|youtube.).*$
      tagging.scriptClassPrefix.regexp = ^(scriptClass:)(.+)$

      document.preprocessorScripts =

      proposalsection.path =

    secret:
      name: youtube-connector-credentials
      server:
        usernameKey: sophora-username
        passwordKey: sophora-password

    jobstore:
      storage:
        storageClass: ssd
        resources:
          requests:
            storage: 50M
    oauth:
      storage:
        storageClass: ssd
        resources:
          requests:
            storage: 50M
```