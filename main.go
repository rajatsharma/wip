package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path"
	"strings"
)

type Language int

const (
	Rust Language = iota
	Typescript
	Go
)

var (
	languageMap = map[string]Language{
		"rust":       Rust,
		"rs":         Rust,
		"typescript": Typescript,
		"ts":         Typescript,
		"go":         Go,
	}
)

func proc(shell string) {
	cwd, _ := os.Getwd()
	log.Printf("Running %s in %s", shell, cwd)

	out, err := exec.Command("sh", "-c", shell).CombinedOutput()
	fmt.Println(string(out))

	if err != nil {
		log.Panicf("Unable to run %s", shell)
	}
}

func ParseLanguage(str string) (Language, bool) {
	c, ok := languageMap[strings.ToLower(str)]
	return c, ok
}

func main() {
	language := os.Args[1]

	if language == "" {
		log.Fatalln("Language/Framework not supplied, aborting")
	}

	parsedLanguage, parsed := ParseLanguage(language)

	if !parsed {
		log.Fatalf("Unknown language supplied, %s", language)
	}

	cwd, err := os.Getwd()
	if err != nil {
		log.Fatalf("Unable to get current dir")
	}

	project := os.Args[2]
	projectPath := path.Join(cwd, project)
	if err = os.MkdirAll(projectPath, os.ModePerm); err != nil {
		log.Fatalf("Unable to create dir %s", projectPath)
	}

	if err := os.Chdir(projectPath); err != nil {
		log.Fatalf("Unable to change dir to %s", projectPath)
	}

	if parsedLanguage == Rust {
		proc("cargo init . --bin")
		os.Exit(0)
	}

	if parsedLanguage == Typescript {
		proc("git clone git@github.com:rajatsharma/project-mu2.git .")
		os.Exit(0)
	}

	if parsedLanguage == Go {
		proc(fmt.Sprintf("go mod init github.com/rajatsharma/%s", project))
		mainFile, err := os.Create("main.go")
		if err != nil {
			log.Fatalln("Unable to create file main.go")
		}

		if _, err := mainFile.WriteString(`package main
func main() {
	println("Hello")
}`); err != nil {
			log.Fatalln("Unable to create file main.go")
		}

		os.Exit(0)
	}
}
