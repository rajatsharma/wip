/*
Copyright © 2021 RAJAT SHARMA <lunasunkaiser@gmail.com>
*/
package cmd

import (
	"os"

	"github.com/spf13/cobra"
)

var rustEditorconfig []byte

func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func SetResources(embeddedRustEditorconfig []byte) {
	rustEditorconfig = embeddedRustEditorconfig
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "wingman",
	Short: "Initialise projects",
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.

func init() {
}
