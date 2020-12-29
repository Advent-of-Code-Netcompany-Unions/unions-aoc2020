use std::time::{SystemTime, UNIX_EPOCH};

pub fn timed(f: fn(&str), input: &str) -> u128 {
    println!("---------------");
    let since_the_epoch = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("Time went backwards");
    let in_ms = since_the_epoch.as_millis();

    let path = format!("./input/input_{}.txt", input);
    f(&path);

    let elapsed_time = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .expect("Time went backwards")
        .as_millis()
        - in_ms;

    println!("AoC {}: {:?} milliseconds", input, elapsed_time);

    elapsed_time
}