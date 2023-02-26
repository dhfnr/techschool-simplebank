-- name: CreateAccount :one
INSERT INTO accounts (
    owner,
    balance,
    currency
) VALUES (
    sqlc.arg('owner'),
    sqlc.arg('balance'),
    sqlc.arg('currency')
) RETURNING *;

-- name: GetAccount :one
SELECT * 
FROM accounts
WHERE id = sqlc.arg('id') LIMIT 1;

-- name: ListAccounts :many
SELECT * 
FROM accounts
ORDER BY id
LIMIT sqlc.arg('limit')
OFFSET sqlc.arg('offset');

-- name: UpdateAccount :exec
UPDATE accounts
SET balance = sqlc.arg('balance')
WHERE id = sqlc.arg('id');

-- name: DeleteAccount :exec
DELETE FROM accounts 
WHERE id = sqlc.arg('id');