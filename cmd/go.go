/*
Copyright © 2021 RAJAT SHARMA <lunasunkaiser@gmail.com>
*/
package cmd

import (
	"os"
	"os/exec"

	"github.com/spf13/cobra"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

var goCmd = &cobra.Command{
	Use:   "go",
	Short: "Create go project",
	Run: func(cmd *cobra.Command, args []string) {
		project := args[0]
		err := os.Mkdir(project, 0755)
		check(err)

		path, err := os.Getwd()
		check(err)

		proc := exec.Command("go", "mod", "init", "github.com/rajatsharma/"+project)
		proc.Dir = path + "/" + project
		out, err := proc.Output()
		check(err)
		println(string(out))
	},
}

func init() {
	rootCmd.AddCommand(goCmd)
}
