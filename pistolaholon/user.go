package main

import "github.com/ethereum/go-ethereum/common"

//User an actor within Holon context
type User struct {
	Address    common.Address `json:"address"`
	PrivateKey string         `json:"privatekey"`
}

//HolonUsers users to test the application
type HolonUsers struct {
	MasterAccount User
	Personas      []User
	Validators    []User
	Consumers     []User
}
