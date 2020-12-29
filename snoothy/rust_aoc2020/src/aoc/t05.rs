use super::util;

struct Seating {
    row: i32,
    column: i32,
}

impl Seating {

    fn find_seat(location: &String) -> (i32, i32) {
        let char_list: Vec<char> = location.chars().collect();
        let row = calculate_direction(&char_list[0 .. 7], 127);
        let column = calculate_direction(&char_list[7 .. 10], 7);

        (row,column)
    }

    fn seat_id(&self) -> i32 {
        self.row * 8 + self.column
    }

}

fn calculate_direction(directions: &[char], top: i32) -> i32 {
    let mut low = 0;
    let mut high = top;
    let mut i = 1;

    for dir in directions {
        let diff = (high - low + 1) / 2;
        match dir {
            // Upper
            'B' | 'R' => {
                if i == directions.len() {
                    return high
                }
                low += diff;
            }
            // Lower
            'F' | 'L' => {
                if i == directions.len() {
                    return low
                }
                high -= diff;
            }
            _ => {}
        }
        i += 1;
    }

    0
}

impl From<&String> for Seating {
    fn from(item: &String) -> Self {
        let (x, y) = Seating::find_seat(item);

        Seating {
            row: x,
            column: y,
        }
    }
}

pub fn run(path: &str) {
    let lines = util::file::lines_from_file(path);

    let mut seats: Vec<Seating> = Vec::new();

    let mut highest = 0;
    for line in lines {
        let seat = Seating::from(&line);
        if highest < seat.seat_id() {
            highest = seat.seat_id()
        }

        seats.push(seat);
    }

    seats.sort_by(|a,b| a.seat_id().partial_cmp(&b.seat_id()).unwrap());
    let mut prev_seat_id = seats[0].seat_id();

    let mut my_seat = 0;
    for seat in seats {
        //println!("{}", seat.seat_id());
        let next_seat = seat.seat_id();
        if (next_seat - 2) == prev_seat_id {
            my_seat = prev_seat_id + 1;
        }
        prev_seat_id = next_seat;
    }

    println!("AoC 5.1 result: {}", highest);
    println!("AoC 5.2 result: {}", my_seat);
}