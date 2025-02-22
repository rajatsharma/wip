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
	Cpp Language = iota
	Typescript
	Go
	Haskell
	Scala
)

var (
	languageMap = map[string]Language{
		"cpp":        Cpp,
		"c++":        Cpp,
		"typescript": Typescript,
		"ts":         Typescript,
		"go":         Go,
		"haskell":    Haskell,
		"hs":         Haskell,
		"scala":      Scala,
		"sc":         Scala,
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
	projectName := path.Base(projectPath)

	if project != "." {
		if err = os.MkdirAll(projectPath, os.ModePerm); err != nil {
			log.Fatalf("Unable to create dir %s", projectPath)
		}

		if err := os.Chdir(projectPath); err != nil {
			log.Fatalf("Unable to change dir to %s", projectPath)
		}
	}

	if parsedLanguage == Cpp {
		mainFile, err := os.Create("main.cpp")
		if err != nil {
			log.Fatalln("Unable to create file main.cpp")
		}

		file := "#include <iostream>\n" +
			"using namespace std;\n" +
			"\n" +
			"int main(int argc, char** argv) { return 0; }" +
			"\n"

		if _, err := mainFile.WriteString(file); err != nil {
			log.Fatalln("Unable to write to file main.cpp")
		}
		return
	}

	if parsedLanguage == Typescript {
		proc("git clone git@github.com:rajatsharma/project-mu2.git .")
		return
	}

	if parsedLanguage == Go {
		proc(fmt.Sprintf("go mod init github.com/rajatsharma/%s", projectName))
		mainFile, err := os.Create("main.go")
		if err != nil {
			log.Fatalln("Unable to create file main.go")
		}

		file := "package main\n" +
			"func main() {\n" +
			"\tprintln(\"Hello\")\n" +
			"}"

		if _, err := mainFile.WriteString(file); err != nil {
			log.Fatalln("Unable to create file main.go")
		}

		return
	}
}
