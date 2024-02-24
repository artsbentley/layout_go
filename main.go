package main

import (
	"fmt"
	"log"
)

func main() {
	config, err := InitConfig(".")
	if err != nil {
		log.Fatalf("cannot load configuration: %v", err)
	}
	fmt.Println("config loaded successfully")
	fmt.Printf("App Name: %s", config.Port)
}
