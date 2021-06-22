#!make
include .env
export

setup:
	docker compose up -d localstack

upload_bundle_to_localstack: env
	cd .. && $(MAKE) test bundle
	aws --endpoint-url=http://localhost:4566 s3 cp ../bundle.tar.gz s3://${BUCKET_NAME}/${COMMIT_SHA}.tar.gz

deploy: env
	cd .. && $(MAKE) app
	docker compose up -d car-store opa

env:
	sed -i "" "s/\(COMMIT_SHA=\)\(.*\)/\1`../get_sha.sh`/" .env
	sed -i "" "s/\(POLICY_PATH=\)\(.*\)/\1`cd ..; ./get_policy_path.sh | sed 's/\//\\\\\//' `/" .env

pump_db:
	./pump_db.sh

down:
	docker compose down