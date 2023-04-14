# Sophora Import Job

A one-time Sophora Importer that runs as a k8s job and imports the data from s3 or http. This chart requires Sophora 4 or higher. 

**Note**: The Cron Job is disabled by default. 

## Extra env variables

Additional environment variables are supported via `importer.extraEnv`. The variables have to be defined in kubernetes env format. 

## Import transformation files via S3 or HTTP

Activate transformations by setting `transformation.enabled` to `true`. Now you can reference one or more zip files via s3 or http 
download (use `transformation.data.use` to set your preferred method. Defaults to s3).
By default, all xsl files should be located in `xsl` and all lib files in `libs` .zip file.
All possible configurations are available in `values.yaml`. 

**Note**: The Sophora Importer needs a `transform.xml` as an entrypoint. The directory containing this file is configurable 
via `transformation.data.transformXslSubDir` and is relative to `transformation.data.xslPath`.

### Simple example

```yaml
transformation:
  enabled: true
  data:
    zipViaS3:
      enabled: true
      secretName: "read-only-bucket-secret"
      bucketName: "bucket-with-transformations"
      zipPaths:
        - "/transformation-data.zip"
```


### Saxon

Oftentimes you want to use Saxon for your transformations. This is quite easy. Set `transformation.data.useSaxon` to `true`,
`transformation.xslTransformerFactory` to `net.sf.saxon.TransformerFactoryImpl` and provide a Saxon licence file
via Kubernetes secret (see next subsection).

#### Advanced example with Saxon

```yaml
transformation:
  enabled: true
  xslTransformerFactory: 
  data:
    zipViaS3:
      enabled: true
      secretName: "read-only-bucket-secret"
      bucketName: "bucket-with-transformations"
      zipPaths:
        - "/transformation-data.zip"
    useSaxon: true
    saxonLicenceSecretName: "saxon-license"
    saxonLicenceSecretKey: "saxon-license.lic"
```

## Upload failures to s3

In on-premise solutions it was easy to access the `failure` directory. In case of this k8s-Job we don't
have access to any files after the job has finished. Therefore, the import-job has a feature that
lets you upload the `failure` directory to a s3 bucket (see `importFailureFilesUpload` in `values.yaml`).
