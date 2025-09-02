# Sophora Image AI

The [Image AI][Image AI] module supports the editorial team in creating image variants in image documents.
Instead of manually selecting clips for each image variant, the clips are calculated automatically
using Google Cloud Vision.

## Secrets

This chart requires secrets to be created prior to installation. In particular, the credentials for
your Google Cloud Platform project must be stored in a secret.

To create the credentials secret, have your credentials JSON file ready. You can export this file
in the IAM section in Google Cloud Platform.

To create the secret, run the following command:

```
kubectl create secret generic sophora-image-ai-gcp-credentials \
	--from-literal "credentials.json=$(cat my-project-credentials.json)"
```

Replace the path to `my-project-credentials.json` with the path to your actual credentials JSON file.

After creating the secret, you can proceed to install the chart.



[Image AI]: https://subshell.com/sophora/modules/sophora-image-ai100.html
