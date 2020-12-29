use super::util;

#[derive(Debug)]
struct Password {
    min: u32,
    max: u32,
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

    fn is_truly_valid(&self) -> bool {
        let letters: Vec<char> = self.code.chars().collect();

        letters.get((self.min-1) as usize).unwrap().eq(&self.letter) ^
            letters.get((self.max-1) as usize).unwrap().eq(&self.letter)
    }
}

pub fn run(path: &str) {
    let passwords = util::file::lines_from_file(path);

    let mut valid_passwords = 0;
    let mut truly_valid_passwords = 0;
    for line in passwords {
        let p = Password::from(&line);
        if p.is_valid() {
            valid_passwords += 1;
        }
        if p.is_truly_valid() {
            truly_valid_passwords += 1;
        }
    }

    println!("AoC 2.1 Result: {:?}", valid_passwords);
    println!("AoC 2.2 Result: {:?}", truly_valid_passwords);
}