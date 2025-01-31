build:
    @just build-solidity
    @just build-wasi

build-solidity:
    @rm -rf "{{SOLIDITY_OUT_DIR}}"
    @mkdir -p "{{SOLIDITY_OUT_DIR}}"
    @forge build --out "{{SOLIDITY_OUT_DIR}}" --contracts ./solidity/contracts --via-ir

build-wasi:
    @rm -f target/wasm32-wasip1/release/*.wasm
    @rm -rf "{{WASI_OUT_DIR}}"
    @mkdir -p "{{WASI_OUT_DIR}}"
    @for C in components/*/Cargo.toml; do \
        echo "Building WASI component in $(dirname $C)"; \
        ( cd $(dirname $C) && cargo component build --release && cargo fmt ); \
    done
    @cp target/wasm32-wasip1/release/*.wasm "{{WASI_OUT_DIR}}/"
