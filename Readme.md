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



https://ethereum.org/en/developers/docs/accounts/



https://ethereum.org/en/developers/docs/transactions/



https://ethereum.org/en/developers/docs/apis/json-rpc/



```shell

[nix-shell:~/project/dummyeth]$ curl -H "Content-Type: application/json" -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0x827E7128925AdBA17ca5B26efFbba47a2cb39325", "latest"],"id":1}' 127.0.0.1:8545



{"jsonrpc":"2.0","id":1,"result":"0x61a80"}

```



geth --datadir ./chain-data -networkid 2022 --unlock 0x827E7128925AdBA17ca5B26efFbba47a2cb39325 --password ./password.txt  --unlock 0x5667D2784166C92199B7ee9746758b439B057192



```

> miner.start()

> personal.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: "100", gasPrice: "1"}, "123456")


"0xa81ad9c7e74447d7756d9db4ebd7635fbc87c99784f5f319206a84f5e0101c5e"

```


smart contract

https://trufflesuite.com/docs/truffle/

https://trufflesuite.com/ganache/

`Ganache` launch a dev chain

mkdir MetaCoin
cd MetaCoin

truffle unbox metacoin

truffle test ./test/TestMetaCoin.sol

truffle test ./test/metacoin.js

truffle compile

truffle develop


var block = web3.eth.getBlock("latest");
console.log("gasLimit: " + block.gasLimit);

personal.unlockAccount(eth.accounts[0])


## must works flow

Create 2 accounts with a empty password file, `./password.txt`. Then we can just press return when need typein password. The files chain node read are stored in `./chain-data/keystore`. The files human read are stored in `account*.txt`.
```shell
geth --datadir=./chain-data --password ./password.txt account new > account1.txt
geth --datadir=./chain-data --password ./password.txt account new > account2.txt
geth --datadir=./chain-data --password ./password.txt account new > account3.txt
```

Then we init ethereum chain. Put the two pub key of accounts in `alloc` field in [./Genesis.json](./Genesis.json). Then we can make two account have some balance when chain was stablished.
> `geth --identity "dummyeth" init ./Genesis.json --datadir ./chain-data`

Launch the private chain. All data of chain were stored in `./chain-data`. The unique id is 2022, just a ramdom number is ok. `--http` enable http rpc api, with scope of `"web3,net,eth,admin,personal"`. `--allow-insecure-unlock` could let us unlock accounts in console or other method. We didn't need other peers, `--nodiscover`. `console` will launch a js console after the chain is established.
> `geth --datadir ./chain-data -networkid 2022 --http --http.api "web3,net,eth,admin,personal" --http.corsdomain="https://remix.ethereum.org" --allow-insecure-unlock --nodiscover console `

Btw, if you don't want use `console` when geth logs flying. a seperate console could be used.
> `geth attach ./chain-data/geth.ipc`

When we enter the console, unlock the two accounts.
```shell
personal.unlockAccount(eth.accounts[0])
personal.unlockAccount(eth.accounts[1])
personal.unlockAccount(eth.accounts[2])
```

Then start miner in console to produce new blocks continuously by `miner.start()`. Stop produce blocks by `miner.stop()`.

Before play with smart contract, let's try other usage of console.

```js
eth.getBalance("0x7f6bf00bcaa307be88d29bc567122e471a7aeb9e")
eth.getBalance(eth.accounts[0])
eth.sendTransaction({ from: eth.accounts[0], to: eth.accounts[1], value: '333' })// need account unlocked.
personal.sendTransaction({from: eth.accounts[0], to: eth.accounts[1], value: "100", gasPrice: "1"}, "123456")// didn't need unlock, but a password.
```

## smart contract

`truffle` doesn't work when follow their tutorial in doc. So let's move to `remix`.

find a runtime to install remixd `npm install -g @remix-project/remixd`

run the remixd process `remixd -s ./src — remix-ide https://remix.ethereum.org`. It will listen on `127.0.0.1:65520`.

Now open `https://remix.ethereum.org`. Connect local workspaces, the latest process we create above, by `FILE EXPLORER` -> `Workspaces` -> `connect to localhost`. Make sure the web ide show `*.sol` same with the files in `./src/*.sol`. Click on the `*sol` file, then choose `Solidity compiler` -> `Compile *.sol` to compile smart contract. Wait it success.

Then we need to connect to local private ethereum chain. Get into `Deploy & run transactions`. In `ENVIRONMENT`, choose `External Http Provider`. Make sure `External HTTP Provider Endpoint` is correct.