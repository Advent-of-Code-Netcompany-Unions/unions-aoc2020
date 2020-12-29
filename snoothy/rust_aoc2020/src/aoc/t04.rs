use super::util;
use std::collections::HashMap;

#[derive(PartialEq, Hash)]
enum Fields {
    BYR,
    IYR,
    EYR,
    HGT,
    HCL,
    ECL,
    PID,
    CID
}

impl Eq for Fields {}

struct Passport {
    fields: HashMap<Fields, String>
}

impl From<&String> for Passport {
    fn from(item: &String) -> Self {
        let mut map= HashMap::new();

        let inputs : Vec<&str> = item.split_whitespace().collect();

        for input in inputs {
            let token: Vec<&str> = input.split_terminator(':').collect();

            let field = token[0];
            let value = token[1];

            match field {
                "byr" => map.insert(Fields::BYR, String::from(value)),
                "iyr" => map.insert(Fields::IYR, String::from(value)),
                "eyr" => map.insert(Fields::EYR, String::from(value)),
                "hgt" => map.insert(Fields::HGT, String::from(value)),
                "hcl" => map.insert(Fields::HCL, String::from(value)),
                "ecl" => map.insert(Fields::ECL, String::from(value)),
                "pid" => map.insert(Fields::PID, String::from(value)),
                "cid" => map.insert(Fields::CID, String::from(value)),
                _ => Option::None
            };
        }

        Passport {
            fields: map
        }
    }
}

impl Passport {

    fn has_valid_fields (&self) -> bool {
        self.fields.contains_key(&Fields::BYR) &&
        self.fields.contains_key(&Fields::IYR) &&
        self.fields.contains_key(&Fields::EYR) &&
        self.fields.contains_key(&Fields::HGT) &&
        self.fields.contains_key(&Fields::HCL) &&
        self.fields.contains_key(&Fields::ECL) &&
        self.fields.contains_key(&Fields::PID)
    }

    fn has_valid_data(&self) -> bool {
        let mut result = true;
        for data in &self.fields {
            result &= match data.0 {
                Fields::BYR => {
                    let val: u32 = data.1.parse().unwrap();
                    val >= 1920 && val <= 2002
                }
                Fields::IYR => {
                    let val: u32 = data.1.parse().unwrap();
                    val >= 2010 && val <= 2020
                }
                Fields::EYR => {
                    let val: u32 = data.1.parse().unwrap();
                    val >= 2020 && val <= 2030
                }
                Fields::HGT => {
                    match data.1.chars().last().unwrap() {
                        'n' => {
                            let split: Vec<&str> = data.1.split_terminator("i").collect();
                            let height: u32 = split[0].parse().unwrap();
                            height >= 59 && height <= 76
                        }
                        'm' => {
                            let split: Vec<&str> = data.1.split_terminator("c").collect();
                            let height: u32 = split[0].parse().unwrap();
                            height >= 150 && height <= 193
                        }
                        _ => false
                    }

                }
                Fields::HCL => {
                    match data.1.chars().next().unwrap() {
                        '#' => (),
                        _ => return false
                    }
                    for c in data.1.chars() {
                        match c {
                            '#' | '0' | '1' | '2' | '3' | '4' | '5' | '6' | '7' | '8' | '9' |
                            'a' | 'b' | 'c' | 'd' | 'e' | 'f' => continue,
                            _ => return false
                        }
                    }

                    true
                }
                Fields::ECL => {
                    match data.1.as_str() {
                        "amb" | "blu" | "brn" | "gry" | "grn" | "hzl" | "oth" => true,
                        _ => false
                    }
                }
                Fields::PID => {
                    match data.1.parse::<i32>() {
                        Ok(_i) => data.1.len() == (9 as usize),
                        Err(_e) => false
                    }
                },
                Fields::CID => true
            }
        }

        result
    }
}

pub fn run(path: &str) {
    let lines = util::file::lines_from_file(path);

    let mut passports: Vec<Passport> = Vec::new();
    let mut card = String::new();
    for line in lines.iter() {
        match line.as_str() {
            "" => {
                passports.push(Passport::from(&String::from(card)));
                card = String::from("")
            },
            _ => {
                card = format!("{}{} ", &card, &line);
            }
        }
    }
    passports.push(Passport::from(&String::from(card)));


    let mut valid_cards = 0;
    let mut valid_data_cards = 0;
    for passport in passports {
        let valid_fields = passport.has_valid_fields();
        valid_cards += match valid_fields {
            true => 1,
            false => 0
        };

        if !valid_fields { continue };

        valid_data_cards += match passport.has_valid_data() {
            true => 1,
            false => 0
        };
    }

    println!("AoC 4.1 result: {}", valid_cards);
    println!("AoC 4.2 result: {}", valid_data_cards);
}