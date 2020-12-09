using Combinatorics

function has_sum_to_number(numbers::Array{Int64}, number::Int64)::Bool
    number_combinations = combinations(numbers, 2)

    for number_combination ∈ number_combinations
        if (sum(number_combination) == number)
            return true
        end
    end

    return false
end

function find_invalid_number(numbers::Array{Int64}, preamble_length::Int)
    preamble_rotation = 0
    preamble = numbers[1:preamble_length]

    next_number_counter = 1 + preamble_length
    xmas_not_yet_hacked = true
    next_number = numbers[next_number_counter]
    while xmas_not_yet_hacked
        if (!has_sum_to_number(preamble, next_number))
            return next_number
        end

        next_number_counter += 1
        if (next_number_counter > size(numbers, 1))
            return -1
        end
        preamble_rotation -= 1
        preamble = circshift(numbers, preamble_rotation)[1:preamble_length]
        next_number = numbers[next_number_counter]
    end
end

function find_elements_sum_to_invalid(numbers::Array{Int64}, invalid_number::Int64)::Array{Int64}

    for i in range(1, stop=size(numbers, 1))
        for j in range(i, stop=size(numbers, 1))
            subnumbers = numbers[i:j]
            if (sum(subnumbers) == invalid_number)
                return subnumbers
            end
        end
    end
    return []
end

function hack_the_xmas(numbers::Array{Int64}, preamble_length::Int, puzzle_part::Int)::Int64
    invalid_number = find_invalid_number(numbers, preamble_length)

    if (puzzle_part == 1)
        return invalid_number
    else
        numbers = find_elements_sum_to_invalid(numbers, invalid_number)
        return minimum(numbers) + maximum(numbers)
    end
end

# data = "resources/09122020/test.txt"
data = "resources/09122020/input.txt"
puzzle_part = 2
preamble_length = 25
numbers = parse.(Int64, readlines(data))
@show hack_the_xmas(numbers, preamble_length, puzzle_part)