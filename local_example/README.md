# OPA Bundle Versioning Local Example

This repository shows how to use OPA's bundle functionality to continuously deploy policy versions together with the matching service version.

## Running the local example

The local example mimics the github workflows to demonstrate deployment upon push/merge to `main`.

1. ### setup
first of all we have to set up our S3 mock. this commands starts localstack which is our local mock of S3, as well as creates a bucket called `my-s3-policies-bucket`
```bash make
 make setup
```
to view the logs you can run
```
docker compose logs -t | sort -u -k 3
```
Once there is a log indicating the bucket is created we can continue to the next step.
This might take a minute.
```
localstack_1  | /usr/local/bin/docker-entrypoint.sh: running /docker-entrypoint-initaws.d/create_bucket.sh
localstack_1  | make_bucket: my-s3-policies-bucket
localstack_1  |
localstack_1  | 2021-04-29 11:10:57,733:API: 192.168.32.2 - - [29/Apr/2021 11:10:57] "PUT /my-s3-policies-bucket HTTP/1.1" 200 -
```

2. ### create and upload bundle
this step mimics the `build_bundle` and `upload_bundle` steps in the `Deploy` [workflow](https://github.com/build-security/opa-bundle-version-example/blob/main/.github/workflows/deploy.yaml) which happens on push/merge to `main`. 
first it creates a bundle and tests the policies. if the tests passed, it uploads the bundle to the local S3 mock.

This step requires the [AWS cli](https://aws.amazon.com/cli/).
```bash
make upload_bundle_to_localstack
```
we can check the logs again and see the bundle was uploaded successfully
```
localstack_1  | 2021-04-29 11:18:30,837:API: 192.168.32.2 - - [29/Apr/2021 11:18:30] "PUT /my-s3-policies-bucket/407f7fd3f121f32799b75c71d0bea63b874c8fe6.tar.gz HTTP/1.1" 200 -
```

3. ### build and deploy
this step mimics what should happen on the `build_app` and `deploy` steps in the `Deploy` workflow which is triggered on push/merge to `main`. 
it builds the app and then deploys it and deploys OPA with it.
note that OPA is deployed with a command that configures which version of the bundle it will download from the S3 and use.
this can be seen in the [docker-compose file](https://github.com/build-security/opa-bundle-version-example/blob/main/local_example/docker-compose.yml).
```
make deploy
```
we can see that OPA is up and it downloaded the matching bundle from S3
```
opa_1        | {"level":"info","msg":"Bundle downloaded and activated successfully. Etag updated to \"d0fc28150d25cbcb6ca1b769ade6b2b5\".","name":"authz","plugin":"bundle","time":"2021-04-29T11:25:42Z"}
```

4. ### validate

As a manager, create a car (this should be allowed):

```bash
curl -H 'Authorization: alice' -H 'Content-Type: application/json' \
    -X PUT localhost:8080/cars/test-car-id \
    -d '{"model": "Toyota", "vehicle_id": "357192", "owner_id": "4821"}'
```

As a car admin, try to delete a car (this should be denied):

```bash
curl -H 'Authorization: kelly' \
    -X DELETE localhost:8080/cars/test-car
```

You can also pump up the car db by running
```
make pump_db
```
---
to stop the example run
```bash
make down
```

## Experiment further

So far so good, but the core concept of this example is continuous deployments.
try creating you own branch, modifying the server and the policy to match, and commit.
then, to redeploy with the new version of the app and the policies, go through steps 2 and 3, and validate the modifications you did like step 4.
check out the [closed PR](https://github.com/build-security/opa-bundle-version-example/pull/1) to see an example.