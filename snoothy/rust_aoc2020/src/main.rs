use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    println!("Rust AoC");

    let filepath = "./input/input_01a.txt";

    let numbers = lines_from_file(&filepath);
    for x in &numbers {
        for y in &numbers {
            if x+y == 2020 {
                println!("AoC 1.1 Result: {:?}", x * y);
            }
        }
    }
}

fn lines_from_file(filename: impl AsRef<Path>) -> Vec<i32> {
    let file = File::open(filename).expect("no such file");
    let buf = io::BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line").parse().unwrap())
        .collect()
}