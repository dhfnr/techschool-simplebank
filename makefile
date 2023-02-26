MIGRATION_STEP=1
MIGRATION_PATH=./db/migration

include .env

# DATABASE
DB_CONN=postgres://$(DATABASE.PG.USER:"%"=%):$(DATABASE.PG.PASSWORD:"%"=%)@$(DATABASE.PG.HOST:"%"=%):$(DATABASE.PG.PORT:"%"=%)/$(DATABASE.PG.DBNAME:"%"=%)?sslmode=$(DATABASE.PG.SSLMODE:"%"=%)

migrate_create:
	@read -p "migration name (do not use space): " NAME \
	&& migrate create -ext sql -dir $(MIGRATION_PATH) -seq $${NAME}

migrate_up:
	@migrate -path $(MIGRATION_PATH) -verbose -database "$(DB_CONN)" up $(MIGRATION_STEP)

migrate_down:
	@migrate -path $(MIGRATION_PATH) -verbose -database "$(DB_CONN)" down $(MIGRATION_STEP)

migrate_drop:
	@migrate -path $(MIGRATION_PATH) -verbose -database "$(DB_CONN)" drop

migrate_version:
	@migrate -path $(MIGRATION_PATH) -database "$(DB_CONN)" version 

sqlc:
	sqlc generate

test:
	go test -v -cover ./...


.PHONY: migrate_create migrate_up migrate_down migrate_drop migrate_version