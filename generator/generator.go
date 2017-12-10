package generator

import (
	"fmt"
	"time"
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