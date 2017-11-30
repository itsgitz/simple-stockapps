package datetime

import (
	"fmt"
	"time"
)

func main() {
	now := time.Now()
	timeToAdd := time.Hour * 24 * (5 - 1)
	justAddIt := now.Add(timeToAdd)
	fmt.Println(now.Format("2006-01-02"))
	fmt.Println(justAddIt.Format("2006-01-02"))	
}