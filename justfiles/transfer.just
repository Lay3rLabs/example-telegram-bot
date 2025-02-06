transfer:
  @just _transfer $(cat "{{CONTRACT_ADDRESS_FILEPATH}}")

_transfer CONTRACT_ADDRESS:
  forge script solidity/scripts/Transfer.s.sol:Transfer \
      "{{ETHEREUM_MNEMONIC}}" \
      "{{CONTRACT_ADDRESS}}" \
      "{{RECIPIENT_ADDRESS}}" \
      1000 \
      --sig "run(string,string,string,uint256)" \
      --rpc-url "{{ETHEREUM_RPC_URL}}" \
      --broadcast
  @just transfer-check-balance

transfer-check-balance:
  @just _transfer-check-balance $(cat "{{CONTRACT_ADDRESS_FILEPATH}}")

_transfer-check-balance CONTRACT_ADDRESS:
    @cast call {{CONTRACT_ADDRESS}} "balanceOf(address)(uint256)" "{{RECIPIENT_ADDRESS}}" --rpc-url "{{ETHEREUM_RPC_URL}}" 
    @echo ^--- current balance of "{{RECIPIENT_ADDRESS}}" on "{{CONTRACT_ADDRESS}}"