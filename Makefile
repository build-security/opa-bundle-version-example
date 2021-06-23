#!make
.PHONY: app bundle test clean

dir := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
bundle := bundle.tar.gz
opa := openpolicyagent/opa:latest
sha := $(shell git rev-parse HEAD)

app:
	docker build --tag car-store ${dir}/app/

bundle:
	docker run -v ${dir}/policies:/policies -v ${dir}/:/mnt ${opa} build -r ${sha} -o /mnt/${bundle} /policies

test: bundle
	docker run -v ${dir}/${bundle}:/${bundle} ${opa} test -v -b /${bundle}

clean:
	rm ${dir}/${bundle}
