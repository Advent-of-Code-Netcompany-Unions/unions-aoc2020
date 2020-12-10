function convert_binary_to_num(binaries)
    num = 0.

    for (index, value) ∈ enumerate(Iterators.reverse(binaries))
        num += ldexp(convert(Float64, value), index-1)
    end

    return num
end

function seat_string_to_num(seat_code::String, comparator::Char)::Float64
    seat_code_array = collect(seat_code)
    seat_code_binary = seat_code_array .== comparator

    return convert_binary_to_num(seat_code_binary)
end

function calculate_seat_id(boarding_pass::String)::NamedTuple{(:row, :col, :id), Tuple{Float64,Float64,Float64}}
    row = seat_string_to_num(boarding_pass[1:7], 'B')
    col = seat_string_to_num(boarding_pass[8:10], 'R')

    return (row = row, col = col, id = row * 8 + col)
end

function is_front_row_seat(seat::NamedTuple{(:row, :col, :id), Tuple{Float64,Float64,Float64}})::Bool
    return seat.row == 1
end

function find_own_seat_id(seats::Array{NamedTuple{(:row, :col, :id), Tuple{Float64,Float64,Float64}}})::Float64
    prev_seat = seats[1]
    curr_seat = undef
    for seat ∈ seats[2:end]
        curr_seat = seat

        if (is_front_row_seat(curr_seat))
            continue
        end
        
        if (curr_seat.id == prev_seat.id + 2)
            return curr_seat.id - 1
        end

        prev_seat = curr_seat
    end

    return NaN
end

function board(boarding_passes::Array{String}, puzzle_part::Int)
    seats = Array{NamedTuple{(:row, :col, :id), Tuple{Float64,Float64,Float64}}}(undef, size(boarding_passes)[1])
    for (index, boarding_pass) ∈ enumerate(boarding_passes)
        seats[index] = calculate_seat_id(boarding_pass)
    end

    sorted_seats = sort(seats, by = λ -> λ.id)

    if (puzzle_part == 1)
        return sorted_seats[end]
    else
        return find_own_seat_id(sorted_seats)
    end
end

# data = "resources/05122020/test.txt"
data = "resources/05122020/input.txt"
puzzle_part = 2

boarding_passes = readlines(data)

@show board(boarding_passes, puzzle_part)