package main

import (
	"bufio"
	"context"
	"fmt"
	"log"
	"math/big"
	"os"
	"time"

	"bitbucket.org/janusplatform/holon.contracts/pistolaholon/proxycontract"

	"github.com/jeffprestes/goethereumhelper"
)

func main() {
	file, err := os.Open("banner3.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)

	for scanner.Scan() { // internally, it advances token based on sperator
		log.Println(scanner.Text()) // token in unicode-char
	}
	log.Println("")
	log.Println("                                Bravo Pistola Mock Data Generator")
	log.Println("")

	log.Println("")
	log.Println("Connecting to Pistola Local Network...")
	log.Println("")
	// client, err := goethereumhelper.GetCustomNetworkClient("http://127.0.0.1:8545")
	client, err := goethereumhelper.GetRinkebyClient()
	if err != nil {
		log.Fatalln("Error: ", err.Error())
		return
	}
	networkID, err := client.NetworkID(context.Background())
	if err != nil {
		log.Fatalln("Error getting network ID: ", err.Error())
		return
	}
	log.Println("Connected to network ID ", networkID)

	log.Println("")
	log.Println("Loading testing accounts...")
	log.Println("")
	err = loadAccounts()
	if err != nil {
		log.Fatalln("Error: ", err.Error())
		return
	}
	log.Println("Accounts loaded.")
	// log.Printf("Accounts: %#v\n", HolonUsersAccounts)

	log.Println("Deploying contract...")
	auth, err := getTransactor(client, "masteraccount")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	contractAddr, trx, holon, err := proxycontract.DeployHolon(auth, client)
	if err != nil {
		log.Fatalln("It was not possible to deploy the contract. Error: ", err.Error())
	}
	log.Println("Contract deployed at: ", contractAddr.Hex())
	var isPending = true
	var counterMaxAttempts = 0
	for isPending {
		fmt.Print(".")
		time.Sleep(2 * time.Second)
		_, isPending, err = client.TransactionByHash(context.Background(), trx.Hash())
		if err != nil {
			log.Fatalln("Error checking if a transaction is mining pending. Error: ", err)
			return
		}
		if !isPending {
			break
		}
		counterMaxAttempts++
		if counterMaxAttempts > MaxAttempts {
			log.Fatalln("Attempts number exceeded max attempts limit. Error: ", err)
			return
		}
	}
	fmt.Print("\n")
	txReceipt, err := client.TransactionReceipt(context.Background(), trx.Hash())
	if err != nil {
		log.Fatalln("It was not possible to get deployment transaction receipt. Error: ", err.Error())
	}
	if txReceipt.Status < 1 {
		log.Fatalf("Contract was not deployed. Error: %#v\n", txReceipt.Status)
		return
	}
	log.Printf("Contract was succefully deployed at: %s with status %d\n", contractAddr.Hex(), txReceipt.Status)
	/*



	 */
	log.Println("Adding InfoCategory...")
	auth, err = getTransactor(client, "masteraccount")
	if err != nil {
		log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
		return
	}
	trx, err = holon.AddInfoCategory(auth, big.NewInt(1), "Personal Data")
	if err != nil {
		log.Fatalln("It was not possible to add a info category. Error: ", err.Error())
		return
	}
	isPending = true
	counterMaxAttempts = 0
	for isPending {
		fmt.Print(".")
		time.Sleep(2 * time.Second)
		_, isPending, err = client.TransactionByHash(context.Background(), trx.Hash())
		if err != nil {
			log.Fatalln("Error checking if a transaction is mining pending. Error: ", err)
			return
		}
		if !isPending {
			break
		}
		counterMaxAttempts++
		if counterMaxAttempts > MaxAttempts {
			log.Fatalln("Attempts number exceeded max attempts limit. Error: ", err)
			return
		}
	}
	fmt.Print("\n")
	txReceipt, err = client.TransactionReceipt(context.Background(), trx.Hash())
	if err != nil {
		log.Fatalln("It was not possible to get add info category transaction receipt. Error: ", err.Error())
		return
	}
	if txReceipt.Status < 1 {
		log.Printf("Info Category was not added. Status: %d\n", txReceipt.Status)
		for _, logg := range txReceipt.Logs {
			log.Printf("   Log: %#v\n", logg)
		}
		return
	}
	infoCategoryDetail, err := holon.InfoCategories(nil, big.NewInt(1))
	if err != nil {
		log.Fatalln("It was not possible to get add info category. Error: ", err.Error())
		return
	}
	log.Printf("Info Category added. Information stored is %s\n", infoCategoryDetail)
}
