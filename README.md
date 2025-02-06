# Layer AVS Telegram Bot 

* _**Clone with --recursive or remember to pull the submodules for solidity dependencies**_

## One-time setup

1. Join the [LayerBotTesting](https://t.me/LayerBotTesting) Telegram Group to get bot notifications

2. Copy `.env.example` to `.env` and set the right vars

3. **Follow the [Native Install](https://github.com/Lay3rLabs/WAVS/blob/main/docs/QUICKSTART.md#running-natively) instructions on WAVS if you haven't done so already.**

Short version:

```bash
git clone https://github.com/Lay3rLabs/WAVS.git ~/WAVS

cd ~/WAVS && just install-native ~/wavs-config ~/wavs-data
```

4. **Build all the contracts and components**

```bash
just build
```

5. Install any other generic tooling that pops up... e.g. [just](https://github.com/casey/just), [foundry](https://book.getfoundry.sh/getting-started/installation), [docker](https://www.docker.com/) etc.

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
