mod aoc;
use aoc::util::time::timed as timed;

fn main() {
    println!("Rust AoC 2020");
    let mut total_ms = 0u128;

    total_ms += timed("AoC 01", aoc::t01::run, "01");
    total_ms += timed("AoC 02", aoc::t02::run, "02");
    total_ms += timed("AoC 03", aoc::t03::run, "03");

    println!();
    println!("> Time for all tasks: {} milliseconds", total_ms)
}