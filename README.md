## LOTTERY-ZIYAO-FOUNDRY

**LOTTERY-ZIYAO-FOUNDRY is a Eth Based, automatically run by Chainlink Raffle Project.**

LOTTERY-ZIYAO-FOUNDRY consists of:

-   **Raffle.sol**: Basic Logic is in this file including enterRaffle, Chainlink mechanism.
  
-   **DeployRaffle.sol**: Script that deploys the contract on chain.
  
-   **Interaction-EnterRaffle**: An example shows interaction with the contract.
  
-   **Anvil**: Mock deploy on the local anvil chain.
  
-   **frontEnd**: A demo showing how to interact with the contract on the fornt end.


## Usage

### Build

```shell
$ forge build
```

### Deploy

```shell
$ forge deploy
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### EnterRaffle

```shell
$ forge enter
```

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
