#!/bin/bash
#:[.''.]:>-------------------------------------------
#:[.''.]:> Author:
#:[.''.]:> Marco Antonio Rubio Lopez
#:[.''.]:> markitos.es.info@gmail.com
#:[.''.]:> diciembre 2024
#:[.''.]:>-------------------------------------------

#:[.''.]:>-------------------------------------------
#:[.''.]:><runs>
run:
	go run .
#:[.''.]:>-------------------------------------------

#:[.''.]:>-------------------------------------------
#:[.''.]:><testing>
test:
	go test ./...
testv:
	go test -v ./...
#:[.''.]:>-------------------------------------------

#:[.''.]:>-------------------------------------------
#:[.''.]:><database - migrations - sqlc>
createdb:
	docker exec -it markitos-svc-postgres createdb --username=admin --owner=admin markitos-svc-access
dropdb: 
	docker exec -it markitos-svc-postgres psql -U admin -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = 'markitos-svc-access' AND pid <> pg_backend_pid();"
	docker exec -it markitos-svc-postgres dropdb -U admin markitos-svc-access
#:[.''.]:>-------------------------------------------


#:[.''.]:>-------------------------------------------
#:[.''.]:><security> TODO: ver como hacerlo con otros
appsec-sast-sca:
	docker run --rm -v $(shell pwd):/src returntocorp/semgrep semgrep --config=auto /src --verbose
appsec-gitleaks:
	docker run --rm -v $(shell pwd):/repo zricethezav/gitleaks:latest detect --source /repo
#:[.''.]:>-------------------------------------------


#:[.''.]:>-------------------------------------------
#:[.''.]:><building>
image-push:
	@echo "" && \
	echo "" && \
	echo "Building image markitos-svc-access:$(or $(TAG),1.0.0)" && \
	docker build -t ghcr.io/markitos-es/markitos-svc-access:$(or $(TAG),1.0.0) . && \
	echo "" && \
	echo "Pushing image markitos-svc-access:$(or $(TAG),1.0.0)" && \
	docker push ghcr.io/markitos-es/markitos-svc-access:$(or $(TAG),1.0.0) && \
	echo "" && \
	echo "Image markitos-svc-access:$(or $(TAG),1.0.0) pushed" && \
	docker image rm --force ghcr.io/markitos-es/markitos-svc-access:$(or $(TAG),1.0.0)
	echo "" && \
	echo "Image markitos-svc-access:$(or $(TAG),1.0.0) removed"
	echo "" && \
	echo "Done!"
#:[.''.]:>-------------------------------------------


#:[.''.]:>-------------------------------------------
#:[.''.]:> License: OpenSource :) to pa ti!
#:[.''.]:> markitos.es
#:[.''.]:>-------------------------------------------