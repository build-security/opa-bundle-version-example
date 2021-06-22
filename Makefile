#!make
.PHONY: app bundle test clean

app:
	docker build --tag car-store app/

bundle:
	./build_bundle.sh

test: bundle
	docker run -v `pwd`/bundle.tar.gz:/bundle.tar.gz openpolicyagent/opa:latest test -v -b /bundle.tar.gz

clean:
	rm bundle.tar.gz
