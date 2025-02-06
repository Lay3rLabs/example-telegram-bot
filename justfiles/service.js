const baseObject = {
  id: "%SERVICE_ID%",
  name: "",
  components: {
    component1: {
      wasm: "%DIGEST_1%",
      permissions: {
        allowed_http_hosts: "all",
        file_system: true,
      },
    },
    component2: {
      wasm: "%DIGEST_2%",
      permissions: {
        allowed_http_hosts: "all",
        file_system: true,
      },
    },
  },
  workflows: {
    workflow1: {
      trigger: {
        eth_contract_event: {
          address: "%TRIGGER_ADDRESS%",
          chain_name: "anvil",
          event_hash: [0],
        },
      },
      component: "component1",
      submit: {
        ethereum_contract: {
          chain_name: "anvil",
          address: "%SUBMIT_ADDRESS%",
          max_gas: null,
        },
      },
    },
    workflow2: {
      trigger: {
        eth_contract_event: {
          address: "%TRIGGER_ADDRESS%",
          chain_name: "anvil",
          event_hash: [0]
        },
      },
      component: "component2",
      submit: "none",
    },
  },
  status: "active",
  config: {
    fuel_limit: 100000000,
    host_envs: [
      "WAVS_ENV_TELEGRAM_BOT_TOKEN",
      "WAVS_ENV_TELEGRAM_CHAT_ID"
    ],
    kv: [],
    max_gas: null,
  },
  testable: true,
};

function main() {
  // Grab arguments:
  //  process.argv[0] is 'node'
  //  process.argv[1] is the script name (service.js)
  //  process.argv[2] => output file
  //  process.argv[3..] => placeholders
  const [,, outFile, SERVICE_ID, DIGEST_1, DIGEST_2, TRIGGER_ADDRESS, EVENT_HASH_1, SUBMIT_ADDRESS, EVENT_HASH_2] = process.argv;

  const result = Object.assign({}, baseObject);

  // hex-decode EVENT_HASH_1 and EVENT_HASH_2

  result.id = SERVICE_ID;
  result.components.component1.wasm = DIGEST_1;
  result.components.component2.wasm = DIGEST_2;
  result.workflows.workflow1.trigger.eth_contract_event.address = TRIGGER_ADDRESS;
  result.workflows.workflow1.trigger.eth_contract_event.event_hash = hexFormat(EVENT_HASH_1); 
  result.workflows.workflow2.trigger.eth_contract_event.address = TRIGGER_ADDRESS;
  result.workflows.workflow2.trigger.eth_contract_event.event_hash = hexFormat(EVENT_HASH_2); 
  result.workflows.workflow1.submit.ethereum_contract.address = SUBMIT_ADDRESS;

  // Write to the output file
  const fs = require('fs');
  fs.writeFileSync(outFile, JSON.stringify(result, null));


}

function hexFormat(s) {
  let i = 0;
  let len = s.length;
  let result = [];
  while (i < len) {
    let n = s.substring(i, i + 2);
    if (/^[0-9a-fA-F]+$/.test(n)) {
      result.push(parseInt(n, 16));
    }
    i += 2;
  }
  return result;
}

// Run main if called directly
if (require.main === module) {
  main();
}