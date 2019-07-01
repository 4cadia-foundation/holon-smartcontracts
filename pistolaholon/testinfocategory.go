package main

import (
	"log"
	"math/big"

	"bitbucket.org/janusplatform/holon.contracts/pistolaholon/proxycontract"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/core/types"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/jeffprestes/goethereumhelper"
)

func testAddInfoCategory(client *ethclient.Client, holon *proxycontract.Holon) (err error) {
	log.Println("Adding InfoCategories...")
	err = nil
	var auth *bind.TransactOpts
	var trx *types.Transaction
	var infoCategoryDetail string
	for _, infoCateg := range HolonConfigData.InfoCategories {
		log.Printf("    Adding info category %+v\n", infoCateg)
		auth, err = getTransactor(client, "masteraccount", 0)
		if err != nil {
			log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
			return
		}
		trx, err = holon.AddInfoCategory(auth, big.NewInt(int64(infoCateg.Index)), infoCateg.Details)
		if err != nil {
			log.Fatalln("It was not possible to add a info category. Error: ", err.Error())
			return
		}
		_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
		if err != nil {
			log.Fatalln("It was not possible to add a new info category. Error: ", err.Error())
			return
		}
		infoCategoryDetail, err = holon.InfoCategories(nil, big.NewInt(int64(infoCateg.Index)))
		if err != nil {
			log.Fatalln("It was not possible to get add info category. Error: ", err.Error())
			return
		}
		log.Printf("    Info Category added. Information stored is %s\n", infoCategoryDetail)
	}
	return
}
