# Dummy ETH

It's a private ethereum network for play.

## Create accounts

`geth --datadir=./chain-data --password ./password.txt account new > account1.txt`

`geth --datadir=./chain-data --password ./password.txt account new > account2.txt`

The above commands will use string in `password.txt` as password to create accounts with a pair of keys. They will be stored in `./chain-data/keystore/` for chain node and `./account1.txt` for human read. The public key could be found in files.

## Init

Prepare Genesis block config, [Genesis.json](./Genesis.json)
> alloc with the pub key got previous.

`geth --identity "dummyeth" init ./Genesis.json --datadir ./chain-data`

`geth --datadir ./chain-data -networkid 2022`

`geth attach ./chain-data/geth.ipc`

```shell
[nix-shell:~/project/dummyeth]$ geth attach ./chain-data/geth.ipc
Welcome to the Geth JavaScript console!

instance: Geth/v1.10.18-stable/darwin-arm64/go1.17.11
at block: 0 (Thu Jan 01 1970 12:00:00 GMT+1200 (NZST))
 datadir: /Users/moss/project/dummyeth/chain-data
 modules: admin:1.0 debug:1.0 eth:1.0 ethash:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0

To exit, press ctrl-d or type exit
> personal.newAccount()
Passphrase: 
Repeat passphrase: 
"0x7f6bf00bcaa307be88d29bc567122e471a7aeb9e"
> eth.getBalance("0x7f6bf00bcaa307be88d29bc567122e471a7aeb9e")
0
> miner.start()
null
> eth.getBalance("0x7f6bf00bcaa307be88d29bc567122e471a7aeb9e")
775000000000000000000
> miner.stop()
null
> 
```

miner.setEtherbase("7df9a875a174b3bc565e6424a0050ebc1b2d1d82")