/*
Copyright © 2021 RAJAT SHARMA <lunasunkaiser@gmail.com>
*/
package cmd

import (
	"os"

	tp "github.com/rajatsharma/tiny-proc"
	"github.com/spf13/cobra"
)

var goCmd = &cobra.Command{
	Use:   "go",
	Short: "Create Go project",
	Run: func(cmd *cobra.Command, args []string) {
		project := args[0]
		err := os.Mkdir(project, 0755)
		check(err)

		path, err := os.Getwd()
		check(err)

		cwd := path + "/" + project
		check(tp.Proc([]string{"go", "mod", "init", "github.com/rajatsharma/" + project}, &cwd))
	},
}

func init() {
	rootCmd.AddCommand(goCmd)
}
