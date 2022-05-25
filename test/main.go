package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"github.com/hazelcast/hazelcast-go-client"
	"k8s.io/apimachinery/pkg/util/wait"
	"log"
	"net/http"
	"sync"
	"time"
)

type Response struct {
	PublicDNS string `json:"public_dns"`
}

func main() {
	fillMapp()
}

func getPublicAddress() string {
	publicAddress := &Response{}
	resp, _ := http.Get("http://127.0.0.1:5000/cluster/public-dns")
	err := json.NewDecoder(resp.Body).Decode(publicAddress)
	if err != nil {
		panic(err)
	}
	return publicAddress.PublicDNS
}

func fillMapp() {
	var address = getPublicAddress()
	var mapName string
	flag.Parse()
	var wg sync.WaitGroup
	config := hazelcast.Config{}
	cc := &config.Cluster
	cc.Network.SetAddresses(address)
	cc.Name = "amazon"
	ctx := context.Background()
	client, err := hazelcast.StartNewClientWithConfig(ctx, config)
	if err != nil {
		panic(err)
	}
	fmt.Println("Successful connection!")
	fmt.Println("Starting to fill the map with entries...")
	m, err := client.GetMap(ctx, mapName)
	m.Clear(ctx)
	if err != nil {
		panic(err)
	}
	for i := 1; i <= 100; i++ {
		wg.Add(1)
		i := i
		go func() {
			defer wg.Done()
			for j := 1; j <= 100; j++ {
				value := fmt.Sprintf("%d-%d", i, j)
				mapInjector(ctx, m, i, value)
			}
		}()
	}
	wg.Wait()
	WaitForMapSize(ctx, m, 100, 5*time.Second, 10*time.Minute)
	size, err := m.Size(ctx)
	fmt.Printf("Finish to fill the map with entries: %d", size)
	err = client.Shutdown(ctx)
	if err != nil {
		panic(err)
	}
}

func mapInjector(ctx context.Context, m *hazelcast.Map, key int, longString string) {
	fmt.Printf("Value: %d is putting into map.\n", key)
	_, _ = m.Put(ctx, key, longString)
}

func WaitForMapSize(ctx context.Context, m *hazelcast.Map, expectedSize int, interval time.Duration, timeout time.Duration) {
	var size int
	if err := wait.Poll(interval, timeout, func() (bool, error) {
		size, _ = m.Size(ctx)
		return size == expectedSize, nil
	}); err != nil {
		log.Fatalf("Error waiting for map size to reach expected number %v", size)
	}
}
