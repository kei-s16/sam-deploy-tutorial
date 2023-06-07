include .env

install: network build

build:
	sam build

compose:
	docker compose -f $(CURDIR)/local/compose.yaml up -d

serve:
	docker compose -f $(CURDIR)/local/compose.yaml up -d
	sam local start-api --docker-network sam-network

invoke:
	docker compose -f $(CURDIR)/local/compose.yaml up -d
	sam local invoke --docker-network sam-network -e $(CURDIR)/events/post.json

network:
	docker network create sam-network

migrate:
	docker compose -f $(CURDIR)/local/compose.yaml up -d
	aws dynamodb create-table --cli-input-json file://local/$(LOCAL_DYNAMODB_TABLE_DEFINITION) --endpoint-url $(LOCAL_DYNAMODB_ENDPOINT)

drop:
	docker compose -f $(CURDIR)/local/compose.yaml up -d
	aws dynamodb delete-table --table-name $(LOCAL_DYNAMODB_TABLE_NAME) --endpoint-url $(LOCAL_DYNAMODB_ENDPOINT)

stop:
	docker compose -f $(CURDIR)/local/compose.yaml down

clean:
	docker compose -f $(CURDIR)/local/compose.yaml down
	docker network rm sam-network
