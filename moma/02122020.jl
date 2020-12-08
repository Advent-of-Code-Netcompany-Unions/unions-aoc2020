function extract_password_and_policy_info(password_and_policy::String)::Tuple{String, Char, Int, Int}
    regex = r"(?<first_number>\d+)-(?<second_number>\d+)\s(?<letter_match>[a-zA-Z]):\s(?<password>\w+)"
    m = match(regex, password_and_policy)
    
    return (m[:password], m[:letter_match][1], parse(Int, m[:first_number]), parse(Int, m[:second_number]))
end

function is_valid_password_count(password::String, letter_match::Char, minimum_occurence::Int, maximum_occurence::Int)::Bool
    occurences = count(α -> (α == letter_match), password)

    return minimum_occurence <= occurences && occurences <= maximum_occurence
end

function is_valid_password_position(password::String, letter_match::Char, first_position::Int, second_position::Int)::Bool
    letter_in_pos_a = password[first_position] == letter_match
    letter_in_pos_b = password[second_position] == letter_match

    return (letter_in_pos_a && !letter_in_pos_b) || (!letter_in_pos_a && letter_in_pos_b)
end

function find_valid_passwords(passwords_and_policies::Array{String, 1}, puzzle_part::Int)::BitArray
    are_valid = falses(size(passwords_and_policies))
    for (index, password_and_policy) ∈ enumerate(passwords_and_policies)
        (password, letter_match, first_number, second_number) = extract_password_and_policy_info(password_and_policy)
        if (puzzle_part == 1)
            are_valid[index] = is_valid_password_count(password, letter_match, first_number, second_number)
        else
            are_valid[index] = is_valid_password_position(password, letter_match, first_number, second_number)
        end
    end

    return are_valid
end

# data = "resources/02122020/test.txt"
data = "resources/02122020/input.txt"
puzzle_part = 2

parsed_input = readlines(data)
valid_passwords = find_valid_passwords(parsed_input, puzzle_part)
@show sum(valid_passwords)