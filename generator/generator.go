package generator

import (
	"fmt"
	"time"
	"strings"
)

// generate item ID number as random number using nanosecond
func GenerateID() string {
	now := time.Now()
	return fmt.Sprintf("%d", now.Nanosecond())
}

// generate owner ID
func GenerateOwnerID() string {
	now := time.Now()
	return fmt.Sprintf("%d%d", now.Year(), now.Nanosecond())
}

func GenerateTimeSplit(date string) []string {
	split := strings.Split(date, " ")
	return split[1]
}