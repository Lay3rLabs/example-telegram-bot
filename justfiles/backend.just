start-backend:
  @just stop-backend
  @echo "starting Anvil..."
  @anvil > /dev/null 2>&1 &
  @echo "waiting a second before starting WAVS..."
  @sleep 1
  @wavs --home=./config > /dev/null &
  @echo "done!"

stop-backend:
  @-just _clean-wavs > /dev/null 2>&1
  @-killall -9 anvil > /dev/null 2>&1

_clean-wavs:
  -killall -9 wavs
  rm -rf ./.wavs-data