package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

var (
	offline = flag.Bool("offline", false, "Download illustrations")
)

type Illustration struct {
	Id    string `json:"_id"`
	Title string `json:"title"`
	Image string `json:"image"`
	Slug  string `json:"slug"`
}

type ApiResponse struct {
	Illustrations []Illustration `json:"illos"`
	HasMore       bool           `json:"hasMore"`
	NextPage      int            `json:"nextPage"`
}

func getIllustrations() (illustrations []Illustration) {
	baseUrl := "https://undraw.co/api/illustrations?page="

	for inx := 0; ; inx++ {
		log.Printf("Downloading page %d\n", inx)

		// Get the response
		response, err := http.Get(baseUrl + strconv.Itoa(inx))
		if err != nil {
			log.Fatalln(err)
		}

		// Read the response body
		data, err := io.ReadAll(response.Body)
		if err != nil {
			log.Fatalln(err)
		}

		// Unmarshal the data
		var apiResponse ApiResponse
		err = json.Unmarshal(data, &apiResponse)
		if err != nil {
			log.Fatalln(err)
		}

		illustrations = append(illustrations, apiResponse.Illustrations...)

		if apiResponse.HasMore == false {
			break
		}
	}

	for inx, illustration := range illustrations {
		illustrations[inx].Id = kebabCase(illustration.Title)
	}

	sort.Slice(illustrations, func(i, j int) bool {
		return illustrations[i].Id < illustrations[j].Id
	})

	return
}

func kebabCase(value string) string {
	value = strings.ToLower(strings.TrimSpace(value))
	value = strings.ReplaceAll(value, " ", "_")
	value = strings.ReplaceAll(value, "-", "_")

	startNum := regexp.MustCompile(`^\d+`)
	value = startNum.ReplaceAllStringFunc(value, func(match string) string {
		return "_" + match
	})
	value = strings.Replace(value, "void", "void_", 1)
	return value
}

func downloadIllustrations(illustrations []Illustration) (downloads []string) {

	illustrationDir := "assets/illustrations"
	err := os.MkdirAll(illustrationDir, 0755)
	if err != nil {
		log.Fatalln(err)
	}

	for _, illustration := range illustrations {

		name := kebabCase(illustration.Title)

		log.Printf("Downloading illustration %s\n", name)

		// Get the response
		response, err := http.Get(illustration.Image)
		if err != nil {
			log.Fatalln(err)
		}

		// Read the response body
		data, err := io.ReadAll(response.Body)
		if err != nil {
			log.Fatalln(err)
		}

		// Save the file
		filename := illustrationDir + "/" + name + ".svg"
		err = os.WriteFile(filename, data, 0644)
		if err != nil {
			log.Fatalln(err)
		}

		downloads = append(downloads, filename)
	}

	return downloads
}

func fixDoubleId(illustrations []Illustration) {
	ids := make(map[string]int)

	for inx, illustration := range illustrations {
		id := illustration.Id
		if iny, ok := ids[id]; ok {
			id += fmt.Sprintf("_%d", iny)
		}

		illustrations[inx].Id = id
		ids[illustration.Id]++
	}
}

func updateLib(illustrations []Illustration, locations []string) {
	dart := `library undraw;
			// ignore_for_file: unused_field
			/// Enums to help locate the correct illustration
			enum UnDrawIllustration {`

	for _, illustration := range illustrations {
		dart += "/// Title: " + illustration.Title + "\n"
		dart += "/// <br/>\n"
		dart += "/// <img src=\"" + illustration.Image + "\" alt=\"" + illustration.Title + "\" width=\"200\"/>\n"
		dart += illustration.Id + ",\n"
	}

	dart += `}`

	dart += `/// Map of illustrations with url to download
			const Map<UnDrawIllustration, String> illustrationMap = {`

	for inx, location := range locations {
		illustration := illustrations[inx]
		dart += "UnDrawIllustration." + illustration.Id + ": " + `"` + location + `",`
	}

	dart += `};`

	err := os.WriteFile("lib/illustrations.g.dart", []byte(dart), 0644)
	if err != nil {
		log.Fatalln(err)
	}

	// Execute dart format on the file
	err = exec.Command("dart", "format", "lib/illustrations.g.dart").Run()
	if err != nil {
		log.Fatalln(err)
	}
}

func buildIllustrationMap(illustrations []Illustration) (src []string) {
	for _, illustration := range illustrations {
		src = append(src, illustration.Image)
	}

	return
}

func main() {
	log.SetFlags(log.LstdFlags | log.Lshortfile)
	flag.Parse()

	log.Printf("Collected illustrations:")
	illustrations := getIllustrations()

	var locations []string
	if *offline {
		log.Printf("Downloading illustrations:")
		locations = downloadIllustrations(illustrations)
	} else {
		locations = buildIllustrationMap(illustrations)
	}

	fixDoubleId(illustrations)

	updateLib(illustrations, locations)
}
