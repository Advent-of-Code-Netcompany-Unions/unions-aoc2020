function anyone_answered_yes(group_answers)::Int
    return size(unique(Iterators.flatten(group_answers)))[1]
end

function everyone_answered_yes(group_answers)::Int
    return size(intersect(group_answers...))[1]
end

function count_yesses(group::SubString{String}, puzzle_part::Int)::Int
    group_answers = split.(split(group, r"\n"), r"")
    if (puzzle_part == 1)
        return anyone_answered_yes(group_answers)
    else
        return everyone_answered_yes(group_answers)
    end
end

function customs_declaration_forms(groups::Array{SubString{String}}, puzzle_part::Int)::Int
    yesses = zeros(size(groups))
    for (index, group) ∈ enumerate(groups)
        yesses[index] = count_yesses(group, puzzle_part)
    end

    return cumsum(yesses)[end]
end

# data = "resources/06122020/test.txt"
data = "resources/06122020/input.txt"

puzzle_part = 2

data_input = split(read(data, String), r"\n\n")

@show customs_declaration_forms(data_input, puzzle_part)