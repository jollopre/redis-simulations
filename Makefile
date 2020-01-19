.PHONY: down console out_of_memory events
down:
	docker-compose down
console:
	docker-compose run --rm ruby bash
out_of_memory:
	docker-compose -f ./docker-compose.yml -f ./out_of_memory.yml run --rm ruby ruby out_of_memory.rb || make down
keyspace_notifications:
	docker-compose -f ./docker-compose.yml -f ./keyspace_notifications.yml run --rm ruby ruby keyspace_notifications.rb || make down
