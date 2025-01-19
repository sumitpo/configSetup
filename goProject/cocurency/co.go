package cocurency

type websitechecker func(string) bool

func CheckWebsites(wc websitechecker, urls []string) map[string]bool {
	checkRes := make(map[string]bool)
	for _, url := range urls {
		go func(u string) {
			checkRes[u] = wc(u)
		}(url)
	}
	return checkRes
}
