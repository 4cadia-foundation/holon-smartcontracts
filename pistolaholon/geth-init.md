geth init ./genesis.json --datadir ./tmpgethdata

geth --graphql --metrics --metrics.expensive --pprof --verbosity 3 --fakepow --mine --minerthreads=1 --miner.etherbase "0x8b542882b80EE26B004E279aA547e6FF6F6B2974" --maxpeers 0 --datadir ./tmpgethdata --networkid="15397" --ws --wsaddr "127.0.0.1" --identity "pistola" --rpc --rpcaddr "127.0.0.1" --rpccorsdomain "*" --wsapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --rpcapi "admin,db,eth,debug,miner,net,shh,txpool,personal,web3" --ethash.dagdir ./tmpgethdag --ethash.dagsondisk 1

geth --networkid 15397 --dev --dev.period 1 --rpc --rpcapi "db,eth,net,web3,miner,personal" --datadir ./tmpgethdata 

geth attach ipc:///home/jeffprestes/go/src/bitbucket.org/janusplatform/holon.contracts/pistolaholon/tmpgethdata/geth.ipc

Etherbase - ethercoin - privatekey 41206f7264656d20646f7320747261746f726573206ec3a36f20616c74657261

web3.fromWei(eth.getBalance("0x8b542882b80EE26B004E279aA547e6FF6F6B2974"), "ether");