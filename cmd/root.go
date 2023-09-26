package cmd

import (
	"fmt"
	"net/http"

	"github.com/adamgoose/put2aria/put2aria"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

var rootCmd = &cobra.Command{
	Use: "put2aria",
	RunE: put2aria.RunE(func(p2a *put2aria.Put2Aria) error {
		fmt.Printf("Listening on %s\n", viper.GetString("listen"))
		return http.ListenAndServe(viper.GetString("listen"), p2a)
	}),
}

func Execute() error {
	return rootCmd.Execute()
}
