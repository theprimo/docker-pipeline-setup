.PHONY: help


help:
	@echo 	supported commands
	@echo 	compose-build
	@echo 	compose-up
	@echo 	compose-down
	@echo 	compose-clean

compose-build:
	docker-compose up -d --build
compose-up:
	docker-compose up -d
compose-down:
	docker-compose down
compose-clean:
	docker-compose down -v
