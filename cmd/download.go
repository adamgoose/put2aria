package cmd

import (
	"strconv"

	"github.com/adamgoose/put2aria/put2aria"
	"github.com/spf13/cobra"
)

var downloadCmd = &cobra.Command{
	Use:     "download {file-id}",
	Aliases: []string{"d", "dl"},
	Args:    cobra.ExactArgs(1),
	RunE: put2aria.RunE(func(args []string, p2a *put2aria.Put2Aria) error {
		fileID, err := strconv.Atoi(args[0])
		if err != nil {
			return err
		}

		return p2a.Download(int64(fileID))
	}),
}

func init() {
	rootCmd.AddCommand(downloadCmd)
}
