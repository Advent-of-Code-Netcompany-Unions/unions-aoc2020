use super::util;


pub fn run(path: &str) {
    println!("AoC 15.1 answer: {}", runCalculation(2021));
    println!("AoC 15.2 answer: {}", runCalculation(30000001));
}

fn runCalculation(size: usize) -> i32 {
    let input = [0,12,6,13,20,1,17];
    let mut numbers: Vec<(i32, i32)> = vec![(0,0); size];

    for round in 0..7 {
        numbers[input[round]] = ((round as i32)+1, 0);
    }

    let mut lastSpoken = 0i32;

    for round in 8..size {
        lastSpoken = match numbers[lastSpoken as usize].1 {
            0 => 0,
            _ => numbers[lastSpoken as usize].0 - numbers[lastSpoken as usize].1
        };

        numbers[lastSpoken as usize].1 = numbers[lastSpoken as usize].0;
        numbers[lastSpoken as usize].0 = round as i32;
    }

    lastSpoken
}