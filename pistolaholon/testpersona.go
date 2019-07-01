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

func testAddPersonas(client *ethclient.Client, holon *proxycontract.Holon) {
	log.Println("Adding personas...")
	var err error
	var auth *bind.TransactOpts
	var trx *types.Transaction
	log.Println("Total personas: ", len(HolonConfigData.Personas))
	for indexPersona, persona := range HolonConfigData.Personas {
		log.Printf("Adding Persona %+v ...\n", persona)
		for index, dataInfo := range persona.PersonaDatas {
			auth, err = getTransactor(client, "persona", indexPersona)
			if err != nil {
				log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
				return
			}
			if index == 0 {
				trx, err = holon.AddPersona(auth, big.NewInt(int64(dataInfo.InfoCode)), uint8(dataInfo.DataCategory), dataInfo.Field, dataInfo.Data, big.NewInt(int64(dataInfo.Price)))
				if err != nil {
					log.Fatalln("It was not possible to submit a new persona. Error: ", err.Error())
					return
				}
				_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
				if err != nil {
					log.Fatalln("It was not possible to add a new persona. Error: ", err.Error())
					return
				}
				personaReturn, err := holon.Members(nil, persona.Address)
				if err != nil {
					log.Fatalln("It was not possible to get the new added persona. Error: ", err.Error())
					return
				}
				log.Printf("Persona Address %s\n", personaReturn.PersonalAddress.Hex())
				pData, err := queryPersonaData(holon, personaReturn.PersonalAddress, dataInfo.Field)
				if err != nil {
					log.Fatalln("It was not possible to get the email from the new added persona. Error: ", err.Error())
					return
				}
				log.Printf("Persona added %+v\n\n", pData)
			} else {
				continue
			}
		}
	}
	log.Println("Personas added")
	log.Println("")
	return
}

func testAddDataToPersonas(client *ethclient.Client, holon *proxycontract.Holon) {
	log.Println("Adding data to personas...")
	var err error
	var auth *bind.TransactOpts
	var trx *types.Transaction
	log.Println("Total personas: ", len(HolonConfigData.Personas))
	for indexPersona, persona := range HolonConfigData.Personas {
		for index, dataInfo := range persona.PersonaDatas {
			auth, err = getTransactor(client, "persona", indexPersona)
			if err != nil {
				log.Fatalln("It was not possible to generate transactor to send transaction to blockchain. Error: ", err.Error())
				return
			}
			if index > 0 {
				log.Printf("    Adding data %s to Persona %+v ...\n", dataInfo.Field, persona)
				trx, err = holon.AddData(auth, big.NewInt(int64(dataInfo.InfoCode)), uint8(dataInfo.DataCategory), dataInfo.Field, dataInfo.Data, big.NewInt(int64(dataInfo.Price)))
				if err != nil {
					log.Fatalln("It was not possible to submit a new data to a persona. Error: ", err.Error())
					return
				}
				_, err = goethereumhelper.WaitForTransctionProcessing(client, trx, MaxAttempts, CheckInterval)
				if err != nil {
					log.Fatalln("It was not possible to add a new data to a persona. Error: ", err.Error())
					return
				}
				pData, err := queryPersonaData(holon, persona.Address, dataInfo.Field)
				if err != nil {
					log.Fatalln("It was not possible to get the email from the new added persona. Error: ", err.Error())
					return
				}
				log.Printf("    Persona %s data %s included to her profile %#v\n", persona.Address.Hex(), dataInfo.Field, pData)
			}
		}
	}
	log.Println("Personas' data added")
	log.Println("")
	return
}
