# Foundryup installs nightly by default, let's make that less annoying
export FOUNDRY_DISABLE_NIGHTLY_WARNING := "true" 

# General
ARCH := `uname -m`
REPO_ROOT := `git rev-parse --show-toplevel`

# Ethereum
ETHEREUM_SENDER := "0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266" # Corresponds to ETHEREUM_MNEMONIC
ETHEREUM_MNEMONIC := "test test test test test test test test test test test junk"
ETHEREUM_RPC_URL := "http://localhost:8545"

# CLI
CLI_DEPLOYMENTS_FILEPATH := ".wavs-data/cli/deployments.json"

# WAVS LOG OUTPUT
WAVS_LOG_FILEPATH := ".build-artifacts/wavs.log"

# Build output 
SOLIDITY_OUT_DIR := ".build-artifacts/contracts" 
WASI_OUT_DIR := ".build-artifacts/wasi-components" 

# Deploy output
CONTRACT_ADDRESS_FILEPATH := ".build-artifacts/contract.address"
SERVICE_ID_FILEPATH := ".build-artifacts/service.id"
SERVICE_JSON_FILEPATH := ".build-artifacts/service.json"
DIGEST_PREPARE_FILEPATH := ".build-artifacts/component.prepare.digest"
DIGEST_COMMIT_FILEPATH := ".build-artifacts/component.commit.digest"

# Events
# from openzeppelin IERC20. Get the signature via:
# cast sig-event "event Transfer(address indexed from, address indexed to, uint256 value)"
TRIGGER_TRANSFER_EVENT_NAME := "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
# cast sig-event "event SendTelegram(string operator_id, string message)"
TRIGGER_TELEGRAM_EVENT_NAME := "0xca2fa0b674393f0cbf54d53205bbe68c8686a83d7f446408a36730d0b586a892"

# Transfer
RECIPIENT_MNEMONIC := "obscure bulb raise icon silent vendor sail plug region hood scare myself"
RECIPIENT_ADDRESS := "0xF0e8DA988b924fcf2b5E7C20B2c80f3404AA288D"