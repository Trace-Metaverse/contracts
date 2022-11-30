# Trace Contracts PASS, CAR, TRC, ACE Tokens, Vesting TRC

```bash
RPC=""
PRIVATE_KEY=""
```

```bash
anvil
```

```bash
source .env

forge script script/Deploy.s.sol:Tokens --rpc-url $RPC --broadcast -vvvv
forge script script/Deploy.s.sol:Vesting --rpc-url $RPC --broadcast -vvvv
```
