# Sophora Media Finder

This chart deploys the Sophora Media Finder (for ARD Core).

## What you need (requirements)

This chart requires the following already present in the target namespace:

* An ImagePullSecret for the subshell Docker Registry
* A secret containing BASE64 encoded `<username>:<password>` to access the Asset Research Service of the ARD Mediathek.
* A secret containing username and password to access the sophora server if needed by the plugin implementation.

## Configuration

The application configuration is located underneath `mediafinder.configuration` and is documented at https://subshell.com/docs/mediafinder/5/mediafinder100.html and located at

## Plugin Implementation

There are two possibilities to provide the plugin implementation.

```
mediaFinder:
    plugins:
        source: "sidecar" # "sidecar" or "s3" leave empty for no plugins
        downloadFromS3:
            ...
        copyFromSidecarImage:
            ...
    ...    
```

### Via S3 bucket

Provide an S3 Bucket that contains the plugin implementation. Configure the credentials and paths to jar files in the S3 bucket that should be used.   

### Via sidecar (Container Image)

Provide a container image that contains the plugin implementation. Configure the image and the folder with jar files inside the container image that should be used.
