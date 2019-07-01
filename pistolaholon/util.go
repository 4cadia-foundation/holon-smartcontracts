package main

import (
	"context"
	"crypto/ecdsa"
	"encoding/json"
	"io"
	"io/ioutil"
	"log"
	"math/big"

	"bitbucket.org/janusplatform/holon.contracts/pistolaholon/proxycontract"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/crypto"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/jeffprestes/goethereumhelper"
)

//QueryPersonaData Querying Persona's data
func queryPersonaData(holon *proxycontract.Holon, address common.Address, fieldname string) (ir proxycontract.InfoReturn, err error) {
	// field, data, dataCategory, reputationPoints, validationNumbers, price, err := holon.GetPersonaData(nil, address, fieldname)
	ir.Field, ir.Data, ir.DataCategory, ir.Reputation, ir.Validations, ir.Price, err = holon.GetPersonaData(nil, address, fieldname)
	if err != nil {
		log.Printf("It was not possible to get data from the field %s . Error: %s\n", fieldname, err.Error())
		return
	}
	log.Printf("Persona data details... %#v\n", ir)
	return
}

func getAccountDetails(client *ethclient.Client, actor string, index int) (privateKey *ecdsa.PrivateKey, publicKeyECDSA *ecdsa.PublicKey, fromAddress common.Address, nonce uint64, err error) {
	var prvKey string
	if actor == "masteraccount" {
		prvKey = HolonConfigData.MasterAccount.PrivateKey
	} else if actor == "persona" {
		prvKey = HolonConfigData.Personas[index].PrivateKey
	} else if actor == "validator" {
		prvKey = HolonConfigData.Validators[index].PrivateKey
	} else if actor == "consumer" {
		prvKey = HolonConfigData.Validators[index].PrivateKey
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
	return getAccountDetails(client, "masteraccount", 0)
}

func getTransactor(client *ethclient.Client, actor string, index int) (auth *bind.TransactOpts, err error) {
	var privateKey *ecdsa.PrivateKey
	var nonce uint64
	if actor == "masteraccount" {
		privateKey, _, _, nonce, err = getAccountDetailsMasterAccount(client)
	} else {
		privateKey, _, _, nonce, err = getAccountDetails(client, actor, index)
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

// ReadPluginConfig returns a parsed plugin's config file.
func ReadPluginConfig(reader io.Reader) (PluginConfig, error) {
	dec := json.NewDecoder(reader)

	var plugin PluginConfig
	if err := dec.Decode(&plugin); err != nil {
		return PluginConfig{}, err
	}

	return plugin, nil
}

func loadConfig() (err error) {
	err = nil
	file, err := ioutil.ReadFile("accounts.json")
	if err != nil {
		log.Printf("[loadAccounts] I could not read the testing account definitions: Error: %#v\n", err)
		return
	}
	err = json.Unmarshal([]byte(file), &HolonConfigData)
	if err != nil {
		log.Printf("[loadAccounts] I could not add testing account information Holon testing struct : Error: %#v\n", err)
		return
	}
	return
}

func loadPluginConfig(filePath string) (tmpPluginConfig PluginConfig, err error) {
	err = nil
	file, err := ioutil.ReadFile(filePath)
	if err != nil {
		log.Printf("[loadPluginConfig] I could not read the testing account definitions at [%s]: Error: %#v\n", filePath, err)
		return
	}
	err = json.Unmarshal([]byte(file), &tmpPluginConfig)
	if err != nil {
		log.Printf("[loadPluginConfig] I could not add testing account information from file [%s] with content [%s] to Holon testing struct : Error: %#v\n", filePath, string(file), err)
		return
	}
	return
}

func savePluginConfig(filePath string, tmpPluginConfig PluginConfig) (err error) {
	err = nil
	file, err := json.MarshalIndent(tmpPluginConfig, "", " ")
	if err != nil {
		log.Printf("[savePluginConfig] I could not marshal JSON data to byte array: Error: %#v\n", err)
		return
	}
	err = ioutil.WriteFile(filePath, file, 0774)
	if err != nil {
		log.Printf("[savePluginConfig] I could not save plugin config data [\n%#v\n] to the file %s: Error: %#v\n", tmpPluginConfig, filePath, err)
		return
	}
	return
}
