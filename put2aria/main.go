package put2aria

import (
	"context"
	"net/http"
	"strconv"
	"time"

	"github.com/defval/di"
	"github.com/putdotio/go-putio"
	"github.com/siku2/arigo"
)

// Put2Aria is the main application struct.
type Put2Aria struct {
	di.Inject
	Ctx  context.Context
	Put  *putio.Client
	Aria *arigo.Client
}

// Download downloads a file from Put.io to Aria2.
func (p *Put2Aria) Download(fileID int64) error {
	zipID, err := p.Put.Zips.Create(p.Ctx, fileID)
	if err != nil {
		return err
	}

	var url string
	for {
		time.Sleep(time.Second)

		zip, err := p.Put.Zips.Get(p.Ctx, zipID)
		if err != nil {
			return err
		}

		if zip.URL != "" {
			url = zip.URL
			break
		}
	}

	if _, err := p.Aria.AddURI([]string{url}, nil); err != nil {
		return err
	}

	return nil
}

// ServeHTTP implements http.Handler interface.
func (p *Put2Aria) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseForm(); err != nil || r.Method != http.MethodPost {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	sFileID := r.FormValue("file_id")
	if sFileID == "" {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	fileID, err := strconv.ParseInt(sFileID, 10, 64)
	if err != nil {
		http.Error(w, "Bad request", http.StatusBadRequest)
		return
	}

	if err := p.Download(int64(fileID)); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	w.WriteHeader(http.StatusNoContent)
}
