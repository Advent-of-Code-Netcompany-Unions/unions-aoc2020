use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

pub fn lines_from_file(filename: impl AsRef<Path>) -> Vec<String> {
    let file = File::open(filename).expect("no such file");
    let buf = io::BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line"))
        .collect()
}

pub fn ints_from_file(filename: impl AsRef<Path>) -> Vec<i32> {
    let file = File::open(filename).expect("no such file");
    let buf = io::BufReader::new(file);
    buf.lines()
        .map(|l| l.expect("Could not parse line").parse().unwrap())
        .collect()
}