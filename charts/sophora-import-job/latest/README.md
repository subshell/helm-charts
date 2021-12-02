# Helm Chart: Sophora Import Job for Sophora 4+

## Extra env variables

Additional environment variables are supported via `importer.extraEnv`. The variables have to be defined in kubernetes env format. 

## Import transformation files via S3 or HTTP

Activate transformations with by setting `transformation.enabled` to `true`. Now you can reference one or more zip files via s3 or http 
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