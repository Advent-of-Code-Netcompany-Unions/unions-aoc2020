# using DataStructures
# using Missings

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

    # numbers = missings(Int, limit + 1)
    # numbers[1:starting_offset] = input
    # @show numbers

    prev_number = input[end]
    new_number = nothing
    # turns = [nothing, nothing]
    for turn ∈ range(starting_offset+1; stop=limit)
        # turn = number + 1
        # last_turn = numbers[prev_number]
        last_turns = get(numbers, prev_number, nothing)
        # last_turn = findlast(λ -> λ == num_to_consider, numbers[1:number-1])

        # @show prev_number, last_turns
        
        if (last_turns === nothing)
            turns = [turn-1, turn-1]
        else
            turns = circshift(last_turns, -1)
            turns[2] = turn - 1
        end

        new_number = turns[2] - turns[1]

        # new_number = last_turn === nothing ? 0 : number - last_turn
        # new_number = (last_turns === nothing || last_turn == 0) ? 0 : turn - last_turn
        # @show turn, new_number, turns
        # @show turn, prev_number, new_number, turns, last_turns
        numbers[prev_number] = turns
        prev_number = new_number
    end

    @show prev_number
    # @show numbers

    return prev_number
end

function play_the_memory_game(input::Array{Int, 1}, puzzle_part::Int)::Int
    local limit
    if (puzzle_part == 1)
        limit = 2020
        # limit = 20
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