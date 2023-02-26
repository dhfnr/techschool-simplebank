package db

import (
	"context"
	"fmt"
	"log"
	"os"
	"testing"
	"time"

	"github.com/jackc/pgx/v4/pgxpool"
	_ "github.com/lib/pq"
)

const (
	dbSource = "postgres://dhafin:dhafin123@127.0.0.1:5432/simple_bank?sslmode=disable"
	maxConns = 10
)

var testQueries *Queries

func TestMain(m *testing.M) {
	// Replace the values below with your database credentials
	poolConfig, err := pgxpool.ParseConfig(dbSource)
	if err != nil {
		log.Fatal("failed to parse database config")
	}

	// Set maximum number of connections in the pool
	poolConfig.MaxConns = maxConns

	// Create a new connection pool
	pool, err := pgxpool.ConnectConfig(context.Background(), poolConfig)
	if err != nil {
		log.Fatal("cannot connect to database pool", err)
	}

	// Ping the database to ensure the connection is working
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	err = pool.Ping(ctx)
	if err != nil {
		log.Fatal("failed to ping database")
	}

	fmt.Println("Successfully connected to the database")

	testQueries = New(pool)

	os.Exit(m.Run())

	// Close the connection pool when the program exits
	defer pool.Close()
}
