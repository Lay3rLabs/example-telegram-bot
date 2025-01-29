import 'justfiles/vars.just'
import 'justfiles/build.just'
import 'justfiles/deploy.just'
import 'justfiles/backend.just'
import 'justfiles/clean.just'

help:
  just --list

foo:
  forge script solidity/scripts/Deploy.s.sol:Deploy \
      --rpc-url "{{ETHEREUM_RPC_URL}}" \
      --sig "run(string calldata mnemonic)" "{{ETHEREUM_MNEMONIC}}" \