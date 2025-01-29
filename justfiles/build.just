build:
    @just build-solidity
    @just build-wasi

build-solidity:
    @rm -rf "{{SOLIDITY_OUT_DIR}}"
    @mkdir -p "{{SOLIDITY_OUT_DIR}}"
    @forge build --out "{{SOLIDITY_OUT_DIR}}" --contracts ./solidity/contracts --via-ir

build-wasi:
    @rm -rf "{{WASI_OUT_DIR}}"
    @mkdir -p "{{WASI_OUT_DIR}}"
    @cd component && cargo component build --release
    @cp target/wasm32-wasip1/release/*.wasm "{{WASI_OUT_DIR}}/"
