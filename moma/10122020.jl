function is_joltage_within_range(current_joltage::Int64, new_joltage::Int64)::Bool
    return 3 >= (new_joltage - current_joltage) >= 1
end

function connect_adapters(joltage_adapters::Array{Int64})::Dict{Int64, Int64}
    jolt_differences = Dict{Int64, Int64}()

    previous_joltage = 0
    for current_joltage ∈ joltage_adapters
        joltage_difference = current_joltage - previous_joltage
        if (haskey(jolt_differences, joltage_difference))
            jolt_differences[joltage_difference] += 1
        else
            jolt_differences[joltage_difference] = 1
        end
        previous_joltage = current_joltage
    end   

    return jolt_differences
end

function sum_paths(joltage_adapters::Array{Int64}, current_joltage::Int64, visited::Dict{Int64, Int64} = Dict{Int64, Int64}())::Int64
    neighbours = findall(x -> is_joltage_within_range(current_joltage, x), joltage_adapters)

    if (isempty(neighbours))
        return 1
    end

    paths = 0
    for neighbour ∈ neighbours
        neighbour_joltage = joltage_adapters[neighbour]
        if (haskey(visited, neighbour_joltage))
            paths += visited[neighbour_joltage]
        else
            paths += sum_paths(joltage_adapters[joltage_adapters .> current_joltage], neighbour_joltage, visited)
        end
    end

    visited[current_joltage] = paths

    return paths
end

function charge_my_device(joltage_adapters::Array{Int64}, puzzle_part::Int64)::Int64
    push!(joltage_adapters, maximum(joltage_adapters)+3)
    if (puzzle_part == 1)
        jolt_differences = connect_adapters(joltage_adapters)
        return jolt_differences[1] * jolt_differences[3]
    else
        return sum_paths(joltage_adapters, 0)
    end
end

# data = "resources/10122020/testa.txt"
# data = "resources/10122020/testb.txt"
data = "resources/10122020/input.txt"
puzzle_part = 2
joltage_adapters = sort(parse.(Int64, readlines(data)))
@show charge_my_device(joltage_adapters, puzzle_part)