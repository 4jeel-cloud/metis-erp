.PHONY: help dev prod-build prod-run install fresh test lint clean

help:
	@echo "Metis ERP — Development & Production Makefile"
	@echo ""
	@echo "Development:"
	@echo "  make dev        Start all dev servers (Laravel + Vite + Queue + Logs)"
	@echo "  make install    Fresh install (migrate, seed, create admin)"
	@echo "  make fresh      Wipe DB and reinstall"
	@echo "  make test       Run tests"
	@echo "  make lint       Run Pint code style fixer"
	@echo ""
	@echo "Production (Docker):"
	@echo "  make prod-build   Build production Docker image"
	@echo "  make prod-run     Run production container"
	@echo ""
	@echo "Utilities:"
	@echo "  make clean        Clear all caches"

dev:
	composer dev

install:
	php artisan erp:install --no-interaction

fresh:
	php artisan erp:install --no-interaction --force

test:
	php artisan test

lint:
	./vendor/bin/pint

prod-build:
	docker build -f docker/production/Dockerfile -t metis-erp:latest .

prod-run:
	docker run -d --name metis-erp \
		-p 80:80 \
		-p 443:443 \
		-e APP_URL=http://localhost \
		-e APP_ENV=production \
		metis-erp:latest

prod-run-external-db:
	docker run -d --name metis-erp \
		-p 80:80 \
		-e DB_HOST=host.docker.internal \
		-e DB_PORT=3306 \
		-e DB_DATABASE=metis \
		-e DB_USERNAME=metis \
		-e DB_PASSWORD=metis \
		-e APP_URL=http://localhost \
		metis-erp:latest

clean:
	php artisan optimize:clear
	php artisan config:clear
	php artisan route:clear
	php artisan view:clear
	php artisan cache:clear
