function next_index(active::Int, picked::Array{Int, 1}, N::Int = 9)
    k = active - 1
    ind = mod1(k, N)
    while ind in picked
        k -= 1
        ind = mod1(k, N)
    end
    return ind
end

function shuffle_round(cups::Array{Int, 1}, active::Int, limit::Int)::Tuple{Array{Int, 1}, Int}
    c1 = cups[active]
    c2 = cups[c1]
    c3 = cups[c2]

    new_active = cups[c3]
    cups[active] = new_active

    dest = next_index(active, [c1, c2, c3], limit)
    ndest = cups[dest]

    cups[dest] = c1
    cups[c3] = ndest
    
    return cups, new_active
end

function shuffle_the_cups(cups::Array{Int, 1}, active::Int, shuffles::Int, limit::Int = 9)::Array{Int, 1}
    for i ∈ range(1; stop=shuffles)
        cups, active = shuffle_round(cups, active, limit)
    end

    return cups
end

function assemble_cups(cups::Array{Int, 1})::String
    output = ""
    for idx ∈ cups[2:end]
        output *= "$(cups[idx])"
    end

    return output
end

function get_linked_list(list::Array{Int, 1})::Array{Int, 1}
    linked_list = fill(10, size(list))
    prev_val = first(list)
    for element ∈ list
        linked_list[prev_val] = element
        prev_val = element
    end

    return linked_list
end

function crab_cups(input::String, puzzle_part::Int)
    cups = get_linked_list(parse.(Int, split(input, "")))

    if (puzzle_part == 1)
        shuffled_cups = shuffle_the_cups(cups, 3, 100, 9)

        return foldl(=>, shuffled_cups)
    else
        active = 2
        append!(cups, range(11; length=1_000_000 - 10))
        append!(cups, active)
        shuffled_cups = shuffle_the_cups(cups, active, 10_000_000, 1_000_000)
        return "$(shuffled_cups[1] * shuffled_cups[shuffled_cups[1]])"
    end
end

curr_day = string(split(split(@__FILE__, "/")[end], ".jl"; keepempty=false)[1])
# data = "$(@__DIR__)/resources/$curr_day/test.txt"
data = "$(@__DIR__)/resources/$curr_day/input.txt"

str = read(open(data), String)
puzzle_part = 2

@show crab_cups(str, puzzle_part)