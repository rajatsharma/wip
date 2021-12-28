/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

*/
package main

import (
	_ "embed"

	"github.com/rajatsharma/wingman/cmd"
)

//go:embed res/rust.editorconfig
var rustEditorconfig []byte

func main() {
	cmd.Execute()
}
