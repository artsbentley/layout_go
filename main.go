package main

func main() {
	conf, err := config.InitConfig(".")
	if err != nil {
		log.Fatalf("cannot load configuration: %v", err)
}
