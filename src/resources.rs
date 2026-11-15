use bevy::prelude::*;

struct GameResource {
    name: &'static str,
    amount: u32,
    incoming: u32,
    usage_hourly: f64,
    expected_runout_secs: f64,
}
