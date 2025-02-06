deploy:
    @just deploy-ethereum
    @just upload-components
    @just deploy-service

deploy-ethereum:
    @just _deploy-eigen-core
    @just _deploy-eigen-manager
    @just _deploy-eigen-handler

_deploy-eigen-core:
    @wavs-cli deploy-eigen-core --home ./config --chain anvil --eth-mnemonic "{{ETHEREUM_MNEMONIC}}"

_deploy-eigen-handler:
    just _deploy-eigen-handler-inner $(cat "{{CLI_DEPLOYMENTS_FILEPATH}}" | jq -r '.eigen_service_managers.anvil[-1]')

_deploy-eigen-handler-inner HANDLER_ADDRESS:
    @rm -rf broadcast
    forge script solidity/scripts/Deploy.s.sol:Deploy \
        "{{ETHEREUM_MNEMONIC}}" \
        "{{HANDLER_ADDRESS}}" \
        --sig "run(string, string)" \
        --rpc-url "{{ETHEREUM_RPC_URL}}" \
        --broadcast \
        --json 2>&1 > /dev/null
    @cat broadcast/Deploy.s.sol/31337/run-latest.json | jq -r '.transactions[0].contractAddress' | tr -d '\n' > "{{CONTRACT_ADDRESS_FILEPATH}}"

_deploy-eigen-manager:
    @wavs-cli deploy-eigen-service-manager --home ./config --chain anvil --eth-mnemonic "{{ETHEREUM_MNEMONIC}}" \

upload-components:
    @just _upload-component "{{justfile_directory()}}/{{WASI_OUT_DIR}}/prepare.wasm" {{DIGEST_PREPARE_FILEPATH}}
    @just _upload-component "{{justfile_directory()}}/{{WASI_OUT_DIR}}/commit.wasm" {{DIGEST_COMMIT_FILEPATH}}

_upload-component COMPONENT FILEPATH:
    @echo `(wavs-cli upload-component --home ./config --component {{COMPONENT}} | sed '/^$/d' | tail -n 1)` | tr -d '\n' > "{{FILEPATH}}"


deploy-service:
    @just _deploy-service-write-json \
        "service-{{choose('16',HEX)}}" \
        $(cat "{{DIGEST_PREPARE_FILEPATH}}") \
        $(cat "{{DIGEST_COMMIT_FILEPATH}}") \
        $(cat "{{CONTRACT_ADDRESS_FILEPATH}}")
    @just _deploy-service-send


_deploy-service-write-json SERVICE_ID DIGEST_1 DIGEST_2 CONTRACT_ADDRESS:
    @node justfiles/service.js \
        "{{SERVICE_JSON_FILEPATH}}" \
        "{{SERVICE_ID}}" \
        "{{DIGEST_1}}" \
        "{{DIGEST_2}}" \
        "{{CONTRACT_ADDRESS}}" \
        "{{TRIGGER_TRANSFER_EVENT_NAME}}" \
        "{{CONTRACT_ADDRESS}}" \
        "{{TRIGGER_TELEGRAM_EVENT_NAME}}" \


_deploy-service-send:
    @echo ""
    @echo "*** deploying service *** "
    wavs-cli deploy-service-raw --home ./config --service "@{{SERVICE_JSON_FILEPATH}}"
