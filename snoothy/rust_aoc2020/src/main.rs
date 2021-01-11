mod aoc;
use aoc::util::time::timed as timed;

fn main() {
    println!("Rust AoC 2020");
    let mut total_ms = 0u128;

    total_ms += timed(aoc::t01::run, "01");
    total_ms += timed(aoc::t02::run, "02");
    total_ms += timed(aoc::t03::run, "03");
    total_ms += timed(aoc::t04::run, "04");
    total_ms += timed(aoc::t05::run, "05");
    total_ms += timed(aoc::t06::run, "06");

    total_ms += timed(aoc::t15::run, "15");

    println!();
    println!("> Time for all tasks: {} milliseconds", total_ms)
}