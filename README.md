# OPA Bundle Versioning Example

This repository shows how to use OPA's bundle functionality to continuously deploy policy versions together with the matching service version.

`app` directory contains a simple Car-Store python application, that uses OPA for API authorization.

`policies` directory contains the rego policy and the data that are used by OPA for the API authorization of the Car-Store application.

`.github/workflows` directory contains the github workflow responsible for deployments of new app and policy versions.

The python application and the policy are based on the [OPA-Python API Authorization Example](https://github.com/open-policy-agent/example-api-authz-python#opa-python-api-authorization-example).

# The deployment process

On every merge to the `main` branch

1. A bundle containing the policies and the data is created and tested. after the tests pass it's uploaded to an S3 bucket.
2. The new version of the application is built.
3. The new version of the application is deployed.
4. OPA is deployed, configured to use the new bundle that was uploaded to the S3 bucket.

To experiment with the project locally, see `local_example` directory which imitates the github workflows on a local setup.

# Setting up your own deployments
To create your own S3 bucket with the right permissions see [OPA docs](https://www.openpolicyagent.org/docs/latest/management-bundles/#amazon-s3).

To create you github workflows follow the [AWS Guide](https://aws.amazon.com/blogs/containers/create-a-ci-cd-pipeline-for-amazon-ecs-with-github-actions-and-aws-codebuild-tests/).