package handlers

import (
	"encoding/json"
	"log"
	"net/http"
)

type Build struct {
	BuildTime string `json:"buildTime"`
	Commit    string `json:"commit"`
	Release   string `json:"release"`
}

// Home returns a simple HTTP handler
func home(buildTime, commit, release string) http.HandlerFunc {
	return func(w http.ResponseWriter, _ *http.Request) {
		info := Build{
			buildTime, commit, release,
		}

		body, err := json.Marshal(info)
		if err != nil {
			log.Printf("Could not encode info data: %v", err)
			http.Error(w, http.StatusText(http.StatusServiceUnavailable), http.StatusServiceUnavailable)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(body)
	}
}
