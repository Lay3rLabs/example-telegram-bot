# Layer AVS Telegram Bot

* _**git clone git@github.com:Lay3rLabs/example-telegram-bot.git --recursive**_

## One-time setup

0. `git submodule update --init --recursive`

1. `cp .env.example .env`

2. Join the your Telegram Group associated with the chat ID in `.env` to get notifications

3. Setup your system: <https://docs.wavs.xyz/tutorial/2-setup>
    - Rust
    - Cargo Component
    - Docker
    - JQ
    - Foundry
    - Node.js (v21+)


4. **Build all the contracts and components**

```bash
just build
```

That's it!

## Up and running

1. **Start the backend**

```bash
just start-backend
```

This may take some time if you've never started the backend before, but subsequent start-ups should be quick.

2. **Deploy contracts and services**

```bash
just deploy
```

This may take some time if you've never deployed before, but subsequent deployments should be quick.

3. **Execute a token transfer**

```bash
just transfer
```

You should get a Telegram notification in the group

4. **Stop the backend**

```bash
just stop-backend
```

# Implementation notes

Almost everyting is in the [justfiles](justfiles) (using `wavs-cli` and `forge` to do the heavy lifting).

The way this works is it watches for ERC20 events. When an event is picked up it runs in two workflows in one service:

1. "prepare" - writes a random uuid into filestorage (let's call this "operator id"), and sends a WAVS message through the pipeline
2. "commit" - checks that the saved operator id matches the message, and sends out the telegram notification

This isn't bulletproof, but it more-or-less ensures that only one operator sends the message, and that it was verified

The only thing copy/pasted from WAVS are solidity _interfaces_.
