SUDO := if `groups | grep -q docker > /dev/null 2>&1 && echo true || echo false` == "true" { "" } else { "sudo" }
PWD := `pwd`
WAVS_CMD := "docker run --rm --network host -e WAVS_CLI_ETH_MNEMONIC=\"test test test test test test test test test test test junk\" -e WAVS_SUBMISSION_MNEMONIC=\"test test test test test test test test test test test junk\" -v $(pwd):/data -v $(pwd)/cli:/data/.wavs-data/cli ghcr.io/lay3rlabs/wavs:0.3.0-beta"

start-backend:
  @just stop-backend
  @echo "starting Anvil..."
  @anvil > /dev/null 2>&1 &
  @echo "waiting a second before starting WAVS..."
  @sleep 1
  @touch "{{WAVS_LOG_FILEPATH}}"
  @{{SUDO}} {{WAVS_CMD}} wavs --home=/data/config > "{{WAVS_LOG_FILEPATH}}" 2>&1 &
  @echo "done!"

stop-backend:
  @-just _clean-wavs > /dev/null 2>&1
  @-killall -9 anvil > /dev/null 2>&1

_clean-wavs:
  -killall -9 wavs
  rm -rf ./.wavs-data
