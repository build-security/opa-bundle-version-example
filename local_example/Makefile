#!make
include ../Makefile
include .env
export

policy_path := $(shell docker run -v ${dir}/policies:/policies ${opa} parse ../policies/* -f json | jq -r '.package.path[1:] | map(.value) | join("\\/")')

setup:
	docker compose up -d localstack

upload_bundle_to_localstack: env test bundle
	aws --endpoint-url=http://localhost:4566 s3 cp ${dir}/${bundle} s3://${BUCKET_NAME}/${sha}.tar.gz

deploy: env app
	docker compose up -d car-store opa

env:
	sed -i "" "s/\(COMMIT_SHA=\)\(.*\)/\1${sha}/" .env
	sed -i "" "s/\(POLICY_PATH=\)\(.*\)/\1${policy_path}/" .env

pump_db:
	./pump_db.sh

down:
	docker compose down

show_logs:
	docker compose logs -t | sort -u -k 3