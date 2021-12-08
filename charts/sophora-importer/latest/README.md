# Helm Chart: Sophora Importer for Sophora 4+

## Extra env variables

Additional environment variables are supported via `sophora.importer.extraEnv`. The variables have to be defined in kubernetes env format.

## Importer without s3 bucket

If you don't need a s3 bucket for incoming Sophora documents, you can set `sophora.importer.s3Bucket.enabled` to false. This might be useful,
if you only need the SOAP api. The following directories can be referenced in your `application.yaml`:

* success: /import/<instance>/success
* temp: /import/<instance>/temp
* failure: /import/<instance>/failure
* incoming: /import/<instance>/incoming

## Import transformation files via S3 or HTTP

Activate transformations with by setting `transformation.enabled` to `true`. Now you can reference one or more zip files via s3 or http
download (use `transformation.data.use` to set your preferred method. Defaults to s3).
By default, all xsl files should be located in `xsl` and all lib files in `libs` inside the .zip file. 
All possible configurations are available in `values.yaml`. Enabling transformations will create 
the following directories, that can be accessed within the importer configuration:

* `/sophora/additionalLibs`
* `/sophora/xsl`

### Simple Example

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

