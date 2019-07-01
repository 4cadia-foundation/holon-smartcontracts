package main

import (
	"bitbucket.org/janusplatform/holon.contracts/pistolaholon/proxycontract"
	"github.com/ethereum/go-ethereum/common"
)

//User an actor within Holon context
type User struct {
	Address     common.Address             `json:"address"`
	PrivateKey  string                     `json:"privatekey"`
	PersonaData []proxycontract.InfoReturn `json:"personaData"`
}

//HolonConfig users to test the application
type HolonConfig struct {
	MasterAccount  User
	Personas       []User
	Validators     []User
	Consumers      []User
	InfoCategories []InfoCategory
}

//InfoCategory represents a infomational category within Holon Contract
type InfoCategory struct {
	Index   int
	Details string
}
