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

// split date string by "space" character such as:
// 2017-10-10 00:00:00
// it will return []string value like ["2017-10-10", "00:00:00"]
// but we only put one second data of slice, it is "00:00:00"
func GenerateTimeSplit(date string) string {
	time_split := strings.Split(date, " ")
	return time_split[1]
}