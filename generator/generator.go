package generator

import (
	"fmt"
	"time"
	"strings"
	"strconv"
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

func GenerateDateSplit(date string) string {
	time_split := strings.Split(date, " ")
	return time_split[0]
}

// spliting datetime use by "-" character
// 2017-10-10 00:00:00
// first spliting it by "space" character ["2017-10-10", "00:00:00"]
// then spliting it to ===> ["2017", "10", "10"]
func GenerateDateSplitByDash(date_splited string) (int, int, int) {
	time_split := strings.Split(date_splited, "-")
	year, _ := strconv.Atoi(time_split[0])
	month, _ := strconv.Atoi(time_split[1])
	day, _ := strconv.Atoi(time_split[2])
	
	return year, month, day
}