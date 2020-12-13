use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() {
    println!("Rust AoC");

    aoc01();
    aoc02();
}

#[derive(Debug)]
struct Password {
    min: u8,
    max: u8,
    letter: char,
    code: String
}

impl From<&String> for Password {
    fn from(item: &String) -> Self {
        let input : Vec<&str> = item.split_whitespace().collect();
        let values: Vec<&str> = input[0].split_terminator('-').collect();

        Password {
            min: values[0].parse().unwrap(),
            max: values[1].parse().unwrap(),
            letter: input[1].chars().next().unwrap(),
            code: String::from(input[2])
        }
    }
}

impl Password {
    fn is_valid(&self) -> bool {
        let mut count = 0;
        for letter in self.code.chars() {
            if self.letter.eq(&letter) {
                count += 1;
            }
        }
        self.min <= count && self.max >= count
    }
}

fn aoc02() -> () {
    let filepath = "./input/input_02a.txt";
    let passwords = lines_from_file(&filepath);

    let mut valid_passwords = 0;
    for line in passwords {
        let p = Password::from(&line);
        if p.is_valid() {
            valid_passwords += 1;
        }
    }

    println!("AoC 2.1 Result: {:?}", valid_passwords);
}

fn aoc01() -> () {
    let filepath = "./input/input_01a.txt";

    let numbers = ints_from_file(&filepath);

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

fn lines_from_file(filename: impl AsRef<Path>) -> Vec<String> {
    let file = File::open(filename).expect("no such file");
    let buf = io::BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line"))
        .collect()
}

fn ints_from_file(filename: impl AsRef<Path>) -> Vec<i32> {
    let file = File::open(filename).expect("no such file");
    let buf = io::BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line").parse().unwrap())
        .collect()
}