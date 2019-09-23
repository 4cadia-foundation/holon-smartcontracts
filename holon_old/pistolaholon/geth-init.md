geth init ./genesis.json --datadir ./tmpgethdata

geth --graphql --metrics --metrics.expensive --pprof --verbosity 3 --fakepow --mine --minerthreads=1 --miner.etherbase "0x8b542882b80EE26B004E279aA547e6FF6F6B2974" --maxpeers 0 --datadir ./tmpgethdata --networkid="15397" --ws --wsaddr "127.0.0.1" --identity "pistola" --rpc --rpcaddr "127.0.0.1" --rpccorsdomain "*" --wsapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --ethash.dagdir ./tmpgethdag --ethash.dagsondisk 1

geth --networkid 15397 --dev --dev.period 1 --rpc --rpcapi "db,eth,net,web3,miner,personal" --datadir ./tmpgethdata 

geth attach ipc:///home/jeffprestes/go/src/bitbucket.org/janusplatform/holon.contracts/pistolaholon/tmpgethdata/geth.ipc

Etherbase - ethercoin - privatekey 41206f7264656d20646f7320747261746f726573206ec3a36f20616c74657261

web3.fromWei(eth.getBalance("0x8b542882b80EE26B004E279aA547e6FF6F6B2974"), "ether");

// Members is a free data retrieval call binding the contract method 0x08ae4b0c.
//
// Solidity: function members(address ) constant returns(address personalAddress, uint256 pendingDataDeliver, bool exists)
func (_Holon *HolonCaller) Members(opts *bind.CallOpts, arg0 common.Address) (PersonaReturn, error) {
	ret := new(PersonaReturn)
	out := ret
	err := _Holon.contract.Call(opts, out, "members", arg0)
	return *ret, err
}

// HolonValidators is a free data retrieval call binding the contract method 0x8c6cd048.
//
// Solidity: function holonValidators(address ) constant returns(address validatorAddress, uint256 reputation, uint8 strategy, uint256 price, bool exists)
func (_Holon *HolonCaller) HolonValidators(opts *bind.CallOpts, arg0 common.Address) (ValidatorReturn, error) {
	ret := new(ValidatorReturn)
	out := ret
	err := _Holon.contract.Call(opts, out, "holonValidators", arg0)
	return *ret, err
}