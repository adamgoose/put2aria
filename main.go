package main

import (
	"context"
	"log"

	"github.com/adamgoose/put2aria/cmd"
	"github.com/adamgoose/put2aria/put2aria"
	"github.com/defval/di"
	"github.com/putdotio/go-putio"
	"github.com/siku2/arigo"
	"github.com/spf13/viper"
	"golang.org/x/oauth2"
)

func main() {
	if err := put2aria.App.Apply(
		di.Provide(func() *putio.Client {
			oauthToken := viper.GetString("PUTIO_OAUTH_TOKEN")
			tokenSource := oauth2.StaticTokenSource(&oauth2.Token{AccessToken: oauthToken})
			oauthClient := oauth2.NewClient(context.TODO(), tokenSource)

			return putio.NewClient(oauthClient)
		}),
		di.Provide(func() (*arigo.Client, error) {
			c, err := arigo.Dial(
				viper.GetString("ARIA2_RPC_URL"),
				viper.GetString("ARIA2_RPC_SECRET"),
			)

			return &c, err
		}),
	); err != nil {
		log.Fatal(err)
	}

	cmd.Execute()
}

func init() {
	viper.SetEnvPrefix("PUT2ARIA")
	viper.AutomaticEnv()
}
