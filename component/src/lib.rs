use alloy::sol;
use bindings::{
    export,
    lay3r::avs::layer_types::{
        TriggerData, TriggerDataCosmosContractEvent, TriggerDataEthContractEvent,
    },
    Guest, TriggerAction,
};

mod bindings;

struct Component;

impl Guest for Component {
    fn run(trigger_action: TriggerAction) -> std::result::Result<Vec<u8>, String> {
        Ok(Vec::new())
    }
}

sol!("../solidity/Event.sol",);

export!(Component with_types_in bindings);
