# https://clarkgrubb.com/makefile-style-guide#phony-targets

COMPOSE := docker compose

.PHONY: docker build-dev build-prod start restart stop destroy bash clean

.env:
	cp .env.dist .env

docker: .env
	${COMPOSE} pull --ignore-pull-failures --include-deps
	${COMPOSE} build --no-cache

build-dev: clean
	${COMPOSE} run --rm builder bash -c ". nvs.sh use 8 && bin/sbt fastOptJS"
	@if [ -f ./looty/target/web/public/main/looty.html ]; then \
		rm -f ./looty/target/web/public/main/looty.html; \
	fi

build-prod: clean
	${COMPOSE} run --rm builder bash -c ". nvs.sh use 8 && bin/sbt fullOptJS"
	@if [ -f ./looty/target/web/public/main/looty-dev.html ]; then \
		rm -f ./looty/target/web/public/main/looty-dev.html; \
	fi

test:
	${COMPOSE} run --rm builder bash -c "bin/sbt test"

sbt:
	${COMPOSE} run --rm builder bash -c "bin/sbt"

start:
	${COMPOSE} up --detach nginx

restart:
	${COMPOSE} restart nginx

stop:
	${COMPOSE} down

destroy: stop
	${COMPOSE} rm --force --stop --volumes

bash:
	${COMPOSE} run --rm builder bash

clean:
	@if [ -d ./looty/target ]; then \
  		find ./looty/target/ -mindepth 1 -maxdepth 1 -type d ! -path './looty/target/web' -exec rm -rf {} +; \
	fi
	@if [ -d ./looty/target/web ]; then \
		find ./looty/target/web -mindepth 1 -maxdepth 1 -type d ! -path './looty/target/web/public' -exec rm -rf {} +; \
	fi
	@if [ -d ./looty/target/web/public ]; then \
		find ./looty/target/web/public -mindepth 1 -maxdepth 1 -type d ! -path './looty/target/web/public/main' -exec rm -rf {} +; \
	fi
	@if [ -d ./looty/target/web/public/main ]; then \
		find ./looty/target/web/public/main -mindepth 1 -maxdepth 1 -exec rm -rf {} +; \
	fi
	@rm -rf ./project/project/target ./project/target
