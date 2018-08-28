package cmd

import (
	"github.com/hashicorp/logutils"
	"github.com/urfave/cli"
	"log"
	"os"
)

func App() *cli.App {
	app := cli.NewApp()
	//app.Name = "go-skel"
	//app.Usage = "Skelton to help bootstrap a project"
	app.Version = "0.1.0"

	// Global flags
	app.Flags = []cli.Flag{
		cli.StringFlag{
			Name:   "log-level",
			EnvVar: "LOG_LEVEL",
			Value:  "ERROR",
			Usage:  "Set the log level of the command",
		},
	}

	app.Before = configLogger

	app.Commands = []cli.Command{}

	return app
}

func configLogger(cc *cli.Context) error {
	filter := &logutils.LevelFilter{
		Levels:   []logutils.LogLevel{"TRACE", "DEBUG", "INFO", "WARN", "ERROR"},
		MinLevel: logutils.LogLevel(cc.GlobalString("log-level")),
		Writer:   os.Stdout,
	}
	log.SetOutput(filter)
	log.SetFlags(log.LstdFlags | log.Lshortfile)

	return nil
}
