use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    println!("Rust AoC");

    aoc01();

}

fn aoc01() -> () {
    let filepath = "./input/input_01a.txt";

    let numbers = lines_from_file(&filepath);

    let mut result1 : i32 = 0;
    let mut result2 : i32 = 0;

    for x in &numbers {
        for y in &numbers {
            if x+y == 2020 {
                result1 = x * y;

            }
            for z in &numbers {
                if x+y+z == 2020 {
                    result2 = x * y * z;
                }
            }
        }
    }

    println!("AoC 1.1 Result: {:?}", result1);
    println!("AoC 1.2 Result: {:?}", result2);
}

fn lines_from_file(filename: impl AsRef<Path>) -> Vec<i32> {
    let file = File::open(filename).expect("no such file");
    let buf = io::BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line").parse().unwrap())
        .collect()
}