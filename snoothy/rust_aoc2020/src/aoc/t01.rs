use super::util;

pub fn run(path: &str) {
    let numbers = util::file::ints_from_file(path);

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