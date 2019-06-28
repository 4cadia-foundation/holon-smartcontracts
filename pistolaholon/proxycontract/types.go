package proxycontract

import (
	"math/big"

	"github.com/ethereum/go-ethereum/common"
)

//PersonaReturn persona as it is defined in SC
type PersonaReturn struct {
	PersonalAddress    common.Address
	PendingDataDeliver *big.Int
	Exists             bool
}

//InfoReturn data returned from
type InfoReturn struct {
	Field        string
	Data         string
	DataCategory uint8
	Reputation   *big.Int
	Validations  *big.Int
	Price        *big.Int
}

//ValidatorReturn Validator solidity Struct
type ValidatorReturn struct {
	ValidatorAddress common.Address
	Reputation       *big.Int
	Strategy         uint8
	Price            *big.Int
	Exists           bool
}
