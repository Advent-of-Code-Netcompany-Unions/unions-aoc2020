function connect_adapters(joltage_adapters::Array{Int64})::Dict{String, Int64}
    jolt_differences = Dict{String, Int64}("1-jolt"=>0, "2-jolt"=>0, "3-jolt"=>0)

    previous_rating = 0
    for joltage_adapter ∈ joltage_adapters
        current_rating = joltage_adapter

        rating_difference = current_rating - previous_rating

        if (rating_difference > 3 || rating_difference < 1)
            return Dict{String, Int64}()
        end

        key = "$rating_difference-jolt"
        jolt_differences[key] += 1
        previous_rating = current_rating
    end   

    return jolt_differences
end

function sum_paths(joltage_adapters::Array{Int64}, current_joltage::Int64, visited::Dict{Int64, Int64} = Dict{Int64, Int64}())::Int64
    neighbours = findall(x -> 3 >= (x - current_joltage) >= 1, joltage_adapters)

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

    if (haskey(visited, current_joltage))
        visited[current_joltage] += paths
    else
        visited[current_joltage] = paths
    end

    return paths
end

function charge_my_device(joltage_adapters::Array{Int64}, puzzle_part::Int64)::Int64
    push!(joltage_adapters, maximum(joltage_adapters)+3)
    if (puzzle_part == 1)
        jolt_differences = connect_adapters(joltage_adapters)
        return jolt_differences["1-jolt"] * jolt_differences["3-jolt"]
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