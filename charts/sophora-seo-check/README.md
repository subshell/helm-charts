# Sophora SEO Check

The [SEO Check] module supports the editorial team in the on-page content optimization of individual documents in the Sophora CMS.
The SEO Check checks the documents for occurrences of SEO keywords, readability, cross-linking and multimedia. Additionally,
the SEO Check shows relevant information about the document.


## Deployment of Additional Data Files

SEO Check requires additional data files to run. These can be downloaded from the
[documentation](https://subshell.com/docs/seocheck/4/seocheck104.html#Example-Word-Lists-in-German-and-English)
and can then by modified by the administrator.


### Google Cloud Storage Credentials

This chart runs an init container to make the additional files available to SEO Check. The files will be downloaded
from a Google Cloud Storage bucket, where they must be placed by the administrator.

To authenticate with Google Cloud Storage, the init container will use the secret `<chart release name>-init-gcp-credentials`.
This secret must be created prior to the installation of the chart.

To create the credentials secret, have your credentials JSON file ready. You can export this file
in the IAM section in Google Cloud Platform.

To create the secret, run the following command:

```
kubectl create secret generic <chart release name>-init-gcp-credentials \
	--from-literal "credentials.json=$(cat my-project-credentials.json)"
```

Replace `<chart release name>` with the name of your release.
Replace the path to `my-project-credentials.json` with the path to your actual credentials JSON file.


### Google Cloud Storage Base URI

The init container needs to know the base URI of the Google Cloud Storage bucket where it can find the
additional data files. In your `values.yaml` file, you must set `seoCheck.init.googleStorageBaseURI`.

The data files must be placed inside the subfolder `<seoCheck.init.googleStorageBaseURI>/seo-check-data`.

For example:

- `seoCheck.init.googleStorageBaseURI: gs://sophora-seo-check`
- Folder to place additional data files in: `gs://sophora-seo-check/seo-check-data`



[SEO Check]: https://subshell.com/sophora/modules/sophora-seo-check104.html
