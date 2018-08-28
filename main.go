package main

import (
	"log"
	"os"

	"github.com/rynmrtn/go-skel/cmd"
)

func main() {
	app := cmd.App()
	if err := app.Run(os.Args); err != nil {
		log.Printf("[ERROR] command exited with error %s", err)
	}
}
