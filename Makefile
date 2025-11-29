.PHONY: up down build test clean

up:
	docker-compose up -d --build

down:
	docker-compose down

build:
	docker-compose build

test:
	docker exec -it ansible-master ansible all -m ping

clean:
	rm -rf .pytest_cache
