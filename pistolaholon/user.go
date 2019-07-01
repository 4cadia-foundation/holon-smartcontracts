package main

import (
	"github.com/ethereum/go-ethereum/common"
)

//User an actor within Holon context
type User struct {
	Address      common.Address `json:"address"`
	PrivateKey   string         `json:"privatekey"`
	PersonaDatas []PersonaData  `json:"personaData"`
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

//PluginConfig plugin's configuration data
type PluginConfig struct {
	Address common.Address `json:"address"`
	Abi     interface{}    `json:"abi"`
}

//PersonaData Persona's mock data
type PersonaData struct {
	InfoCode     string
	Field        string
	Data         string
	DataCategory string
	Reputation   int
	Validations  int
	Price        string
}
