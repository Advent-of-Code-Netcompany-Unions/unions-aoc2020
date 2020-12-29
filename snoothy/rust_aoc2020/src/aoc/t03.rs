use super::util;

struct Hill {
    row: String
}

#[derive(Debug)]
struct Location {
    x: i32,
    y: i32
}

impl Location {

    fn increment (&mut self, x: i32, y: i32) -> i32 {
        let prev_x = self.x;

        self.x += x;
        self.y += y;

        prev_x
    }
}

impl From<&String> for Hill {
    fn from(item: &String) -> Self {
        Hill {
            row: String::from(item)
        }
    }
}

impl Hill {

    fn is_tree(&self, location: i32) -> i32 {
        let wrap = (location % 31) as usize;

        let space = self.row
            .chars()
            .nth(wrap)
            .unwrap();

        match space {
            '#' => 1,
            _ => 0
        }
    }

}

pub fn run(path: &str) {
    let rows = util::file::lines_from_file(path);
    let mut mountain: Vec<Hill> = Vec::new();
    for row in rows {
        mountain.push(Hill::from(&row));
    }

    let slopes: [(i32,i32); 5] = [(1,1), (3,1), (5,1), (7,1), (1,2)];

    println!("AoC 3.1 result: {}", run_hill(&mountain, slopes[1]));

    let mut result = 1u64;

    for slope in slopes.iter() {
        result *= run_hill(&mountain, *slope) as u64
    }

    println!("AoC 3.2 result: {}", result);
}

fn run_hill(mountain: &Vec<Hill>, slope: (i32, i32)) -> i32 {
    let mut trees = 0;
    let mut location = Location { x: 0, y: 0 };
    while let Some(hill) = mountain.get(location.y as usize) {
        trees += hill.is_tree(location.increment(slope.0, slope.1));
    }

    trees
}