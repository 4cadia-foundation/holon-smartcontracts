package main

import (
	"context"
	"crypto/ecdsa"
	"encoding/json"
	"io/ioutil"
	"log"
	"math/big"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/jeffprestes/goethereumhelper"
)

func getAccountDetails(client *ethclient.Client, actor string) (privateKey *ecdsa.PrivateKey, publicKeyECDSA *ecdsa.PublicKey, fromAddress common.Address, nonce uint64, err error) {
	var prvKey string
	if actor == "masteraccount" {
		prvKey = HolonUsersAccounts.MasterAccount.PrivateKey
	}
	privateKey, err = crypto.HexToECDSA(prvKey)
	if err != nil {
		log.Println("[getAccountDetails] ", err)
		return
	}

	_, fromAddress, err = goethereumhelper.GetPubKey(privateKey)
	if err != nil {
		log.Println("[getAccountDetails] ", err)
		return
	}
	nonce, err = client.PendingNonceAt(context.Background(), fromAddress)
	if err != nil {
		log.Println("[getAccountDetails] ", err)
		return
	}
	return
}

func getAccountDetailsMasterAccount(client *ethclient.Client) (privateKey *ecdsa.PrivateKey, publicKeyECDSA *ecdsa.PublicKey, fromAddress common.Address, nonce uint64, err error) {
	return getAccountDetails(client, "masteraccount")
}

func getTransactor(client *ethclient.Client, actor string) (auth *bind.TransactOpts, err error) {
	var privateKey *ecdsa.PrivateKey
	var nonce uint64
	if actor == "masteraccount" {
		privateKey, _, _, nonce, err = getAccountDetailsMasterAccount(client)
	}
	if err != nil {
		log.Fatalln("It was not possible to obtain actor account information: ", err.Error())
		return
	}
	auth = bind.NewKeyedTransactor(privateKey)
	auth.Nonce = big.NewInt(int64(nonce))
	//auth.GasPrice
	gasPrice, err := client.SuggestGasPrice(context.Background())
	if err != nil {
		log.Fatalln("It was not possible to obtain gas: ", err.Error())
		return
	}
	//auth.GasPrice = gasPrice.Mul(gasPrice, big.NewInt(2))
	gasPrice = big.NewInt(1000000000)
	auth.GasPrice = gasPrice
	auth.GasLimit = 4000000
	return
}

func loadAccounts() (err error) {
	err = nil
	file, err := ioutil.ReadFile("accounts.json")
	if err != nil {
		log.Printf("[loadAccounts] I could not read the testing account definitions: Error: %#v\n", err)
		return
	}
	err = json.Unmarshal([]byte(file), &HolonUsersAccounts)
	if err != nil {
		log.Printf("[loadAccounts] I could not add testing account information Holon testing struct : Error: %#v\n", err)
		return
	}
	return
}
