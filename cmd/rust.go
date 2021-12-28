/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

*/
package cmd

import (
	"os"

	tp "github.com/rajatsharma/tiny-proc"
	"github.com/spf13/cobra"
)

// rustCmd represents the rust command
var rustCmd = &cobra.Command{
	Use:   "rust",
	Short: "Create Rust project",
	Run: func(cmd *cobra.Command, args []string) {
		project := args[0]
		check(tp.Proc([]string{"cargo", "init", project}, nil))

		cwd, err := os.Getwd()
		check(err)

		check(os.WriteFile(cwd+"/"+project+"/.editorconfig", rustEditorconfig, 0644))
	},
}

func init() {
	rootCmd.AddCommand(rustCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// rustCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// rustCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
