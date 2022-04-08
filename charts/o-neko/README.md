# O-Neko

Helm Chart for [O-Neko](https://github.com/subshell/o-neko).

## Requirements

To install O-Neko using this Helm chart you will need to create three secrets manually:

1. A secret containing the MongoDB credentials, e.g.: `k create secret generic mongodb-credentials --from-literal=mongodb-password="SECRET" --from-literal=mongodb-root-password="SECRET" --from-literal=mongodb-replica-set-key="SECRET"`
2. A "credentialsCoderKey" secret: Create the credentialsCoderKey secret, e.g.: `k create secret generic o-neko-credentials-coder-key --from-literal=key="SECRET"`
3. A secret containing the MongoDB URI (incl. the MongoDB password), e.g.: `k create secret generic oneko-mongodb-uri --from-literal=uri="mongodb://o-neko:SECRET@o-neko-db-mongodb-0.mongodb-headless:27017,o-neko-db-mongodb-1.mongodb-headless:27017,o-neko-db-mongodb-2.mongodb-headless:27017/o-neko?"` 
