function initialize_numbers(input::Array{Int, 1})::Dict{Int, Array{Int, 1}}
    numbers = Dict{Int, Array{Int, 1}}()

    for (turn, number) ∈ enumerate(input)
        numbers[number] = [turn, turn]
    end

    return numbers
end

function play_the_game(input, limit)
    starting_offset = size(input, 1)

    numbers = initialize_numbers(input)

    prev_number = input[end]
    new_number = nothing
    for turn ∈ range(starting_offset+1; stop=limit)
        last_turns = get(numbers, prev_number, nothing)       
         
        if (last_turns === nothing)
            turns = [turn-1, turn-1]
        else
            turns = circshift(last_turns, -1)
            turns[2] = turn - 1
        end

        new_number = turns[2] - turns[1]
        numbers[prev_number] = turns
        prev_number = new_number
    end

    return prev_number
end

function play_the_memory_game(input::Array{Int, 1}, puzzle_part::Int)::Int
    local limit
    if (puzzle_part == 1)
        limit = 2020
    else
        limit = 30000000
    end
        
    return play_the_game(input, limit)
end

# data = "resources/15122020/test.txt"
data = "resources/15122020/input.txt"

puzzle_part = 2
data_input = parse.(Int, split(read(data, String), ","))

@show play_the_memory_game(data_input, puzzle_part)