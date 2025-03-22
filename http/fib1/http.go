package main

import (
	"log"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/spf13/viper"
)

var svrPort int
var svrAddr string

func fibonacci(n int) int {
	if n <= 1 {
		return n
	}
	a, b := 0, 1
	for i := 2; i <= n; i++ {
		a, b = b, a+b
	}
	return b
}

func fibonacciHandler(c *gin.Context) {
	nStr := c.Query("n")
	if nStr == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Missing 'n' parameter"})
		return
	}

	// Convert the "n" parameter to an integer
	n, err := strconv.Atoi(nStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid 'n' parameter"})
		return
	}

	// Calculate the Fibonacci number
	result := fibonacci(n)

	// Return the result as JSON
	c.JSON(http.StatusOK, gin.H{
		"input":     n,
		"fibonacci": result,
	})
}

func pingHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "pong"})
}

func versionHandler(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"version": "1"})
}

func cfgParse() {
	viper.SetConfigName("fib1")
	viper.SetConfigType("toml")
	viper.AddConfigPath("./")
	err := viper.ReadInConfig()
	if err != nil {
		log.Fatalf("read config failed: %v", err)
	}
	svrPort = viper.GetInt("server.port")
	svrAddr = viper.GetString("server.addr")
}

func main() {
	r := gin.Default()

	r.GET("/ping", pingHandler)
	r.GET("/fib", fibonacciHandler)
	r.GET("/version", versionHandler)
	r.Run() // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}
