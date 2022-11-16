package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"time"
)

func main() {
	url := os.Getenv("REMOTE_URL")

	for {
		res, err := http.DefaultClient.Get(url)
		if err != nil {
			fmt.Println("error making request: ", err.Error())
			continue
		}

		rBytes, err := ioutil.ReadAll(res.Body)
		if err != nil {
			fmt.Println("error reading body: ", err.Error())
			continue
		}
		fmt.Println("The string body: ", string(rBytes))
		time.Sleep(2 * time.Second)
	}
}
