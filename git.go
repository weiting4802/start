package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"log"
	"os/exec"
	"strings"

	"github.com/sourcegraph/go-diff/diff"
)

type LineChange struct {
	OldLine string `json:"old_line,omitempty"`
	NewLine string `json:"new_line,omitempty"`
	Type    string `json:"type"` // "modified", "added", "removed"
}

type HunkChange struct {
	OldStart int          `json:"old_start"`
	NewStart int          `json:"new_start"`
	Changes  []LineChange `json:"changes"`
}

type FileChange struct {
	File  string       `json:"file"`
	Hunks []HunkChange `json:"hunks"`
}

func main() {
	baseBranch := "main"
	targetBranch := "feature-branch"

	exec.Command("git", "fetch", "--all").Run()

	cmd := exec.Command("git", "diff", baseBranch, targetBranch)
	output, err := cmd.Output()
	if err != nil {
		log.Fatalf("git diff failed: %v", err)
	}

	fileDiffs, err := diff.ParseMultiFileDiff(bytes.NewReader(output))
	if err != nil {
		log.Fatalf("parse diff failed: %v", err)
	}

	var results []FileChange

	for _, fd := range fileDiffs {
		fc := FileChange{
			File:  strings.TrimPrefix(fd.NewName, "b/"),
			Hunks: []HunkChange{},
		}

		for _, hunk := range fd.Hunks {
			hc := HunkChange{
				OldStart: int(hunk.OrigStartLine),
				NewStart: int(hunk.NewStartLine),
				Changes:  []LineChange{},
			}

			var removed, added []string
			lines := bytes.Split(hunk.Body, []byte("\n"))
			for _, line := range lines {
				if len(line) == 0 {
					continue
				}
				switch line[0] {
				case '+':
					added = append(added, string(line[1:]))
				case '-':
					removed = append(removed, string(line[1:]))
				default:
					// 當遇到 context line，先把目前的 removed/added flush
					hc.Changes = append(hc.Changes, pairChanges(&removed, &added)...)
				}
			}
			// flush 最後的
			hc.Changes = append(hc.Changes, pairChanges(&removed, &added)...)

			if len(hc.Changes) > 0 {
				fc.Hunks = append(fc.Hunks, hc)
			}
		}

		if len(fc.Hunks) > 0 {
			results = append(results, fc)
		}
	}

	jsonBytes, err := json.MarshalIndent(results, "", "  ")
	if err != nil {
		log.Fatalf("json marshal failed: %v", err)
	}

	fmt.Println(string(jsonBytes))
}

func pairChanges(removed *[]string, added *[]string) []LineChange {
	var changes []LineChange
	for len(*removed) > 0 || len(*added) > 0 {
		var oldLine, newLine string
		if len(*removed) > 0 {
			oldLine = (*removed)[0]
			*removed = (*removed)[1:]
		}
		if len(*added) > 0 {
			newLine = (*added)[0]
			*added = (*added)[1:]
		}

		if oldLine != "" && newLine != "" {
			changes = append(changes, LineChange{
				Type:    "modified",
				OldLine: oldLine,
				NewLine: newLine,
			})
		} else if oldLine != "" {
			changes = append(changes, LineChange{
				Type:    "removed",
				OldLine: oldLine,
			})
		} else if newLine != "" {
			changes = append(changes, LineChange{
				Type:    "added",
				NewLine: newLine,
			})
		}
	}
	return changes
}
