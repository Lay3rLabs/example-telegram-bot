mod bindings;

use alloy_sol_macro::sol;
use alloy_sol_types::SolValue;
use bindings::{
    export,
    wavs::worker::layer_types::{
        TriggerData, TriggerDataCosmosContractEvent, TriggerDataEthContractEvent,
    },
    Guest, TriggerAction,
};

use wasi::clocks::wall_clock;
use wasi::random::random;

struct Component;

impl Guest for Component {
    fn run(trigger_action: TriggerAction) -> std::result::Result<Vec<u8>, String> {
        match trigger_action.data {
            TriggerData::EthContractEvent(TriggerDataEthContractEvent { log, .. }) => {
                let event: Transfer =
                    wavs_wasi_chain::decode_event_log_data!(log).map_err(|e| e.to_string())?;

                let message = Message {
                    operator_id: get_operator_id()?,
                    message: format!("{} transferred {} to {}", event.from, event.value, event.to),
                };

                Ok(message.abi_encode())
            }
            TriggerData::CosmosContractEvent(_) => {
                Err("expected eth event, got cosmos".to_string())
            }
            TriggerData::Raw(_) => Err("expected eth event, got raw".to_string()),
        }
    }
}

fn get_operator_id() -> Result<String, String> {
    const FILENAME: &str = "operator_id.txt";

    if let Ok(content) = std::fs::read_to_string(FILENAME) {
        return Ok(content);
    }

    let now = wall_clock::now();

    // a random id so we can tell which operator actually sent the event
    let operator_id = format!(
        "{}-{}-{}",
        now.seconds,
        now.nanoseconds,
        const_hex::encode(random::get_random_bytes(8))
    );

    std::fs::write(FILENAME, operator_id.clone()).map_err(|e| e.to_string())?;

    Ok(operator_id)
}

// from openzeppelin IERC20
sol! {
    event Transfer(address indexed from, address indexed to, uint256 value);

    struct Message {
        string operator_id;
        string message;
    }
}

export!(Component with_types_in bindings);
