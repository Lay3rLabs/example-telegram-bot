# Foundryup installs nightly by default, let's make that less annoying
export FOUNDRY_DISABLE_NIGHTLY_WARNING := "true" 

# General
ARCH := `uname -m`
REPO_ROOT := `git rev-parse --show-toplevel`

# Ethereum
ETHEREUM_MNEMONIC := "test test test test test test test test test test test junk"
ETHEREUM_RPC_URL := "http://localhost:8545"

# CLI
CLI_DEPLOYMENTS_FILEPATH := ".wavs-data/cli/deployments.json"

# Build output 
SOLIDITY_OUT_DIR := ".build-artifacts/contracts" 
WASI_OUT_DIR := ".build-artifacts/wasi-components" 

# Deploy output
TRIGGER_ADDRESS_FILEPATH := ".build-artifacts/trigger.address"
SUBMIT_HANDLER_ADDRESS_FILEPATH := ".build-artifacts/submit-handler.address"
SUBMIT_MANAGER_ADDRESS_FILEPATH := ".build-artifacts/submit-manager.address"
SERVICE_ID_FILEPATH := ".build-artifacts/service.id"

# Events
# from openzeppelin IERC20. Get the signature via:
# cast sig-event "event Transfer(address indexed from, address indexed to, uint256 value)"
TRIGGER_EVENT_NAME := "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"