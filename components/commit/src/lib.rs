mod bindings;
mod telegram;

use bindings::{
    export,
    wavs::worker::layer_types::{
        TriggerData, TriggerDataCosmosContractEvent, TriggerDataEthContractEvent,
    },
    Guest, TriggerAction,
};
use alloy_sol_macro::sol;
use telegram::TelegramBot;
use wstd::runtime::block_on;

struct Component;

impl Guest for Component {
    fn run(trigger_action: TriggerAction) -> std::result::Result<Vec<u8>, String> {
        match trigger_action.data {
            TriggerData::EthContractEvent(TriggerDataEthContractEvent { log, .. }) => {
                let event: SendTelegram =
                    layer_wasi::ethereum::decode_event_log_data(log).map_err(|e| e.to_string())?;

                if event.operator_id == get_operator_id()? {
                    block_on(|reactor| async move {
                        let bot = TelegramBot::new(reactor).map_err(|e| e.to_string())?;
                        bot.send_message(event.message)
                            .await
                            .map_err(|e| e.to_string())
                    })?;
                } else {
                    std::fs::write("ERROR.txt", "WRONG OPERATOR ID").map_err(|e| e.to_string())?;
                }

                Ok(Vec::new())
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
    std::fs::read_to_string(FILENAME).map_err(|e| e.to_string())
}

// from openzeppelin IERC20
sol! {
    event SendTelegram(string operator_id, string message);
}

export!(Component with_types_in bindings);
