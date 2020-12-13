mutable struct Congruence
    a::Int128
    n::Int128
end

function solve_congruence_system(p::Congruence, q::Congruence)::Congruence
    _, m1, m2 = gcdx(p.n, q.n)
    x = p.a * m2 * q.n + q.a * m1 * p.n

    return Congruence(mod(x, p.n * q.n), p.n * q.n)
end

function schedules_to_congruences(schedules::Array{Tuple{Int64, Int64}})::Array{Congruence}
    congruences = Array{Congruence}(undef, size(schedules))
    for (idx, schedule) ∈ enumerate(schedules)
        Δt = schedule[1]
        n = schedule[2]
        congruences[idx] = Congruence(mod(n - Δt, n), n)
    end

    return congruences
end

function catch_the_damn_bus(data_input)
    earliest_time = parse(Int, data_input[1])
    running_busses = parse.(Int, filter(bus_id -> bus_id != "x", split(data_input[2], ",")))
    sorted_busses = sort([ (bus_id, bus_id - mod(earliest_time, bus_id)) for bus_id in running_busses ], by = bus_and_delta -> bus_and_delta[2], rev=true)
    return sorted_busses[end][1] * sorted_busses[end][2]
end

# data = "resources/13122020/test.txt"
data = "resources/13122020/input.txt"
puzzle_part = 2
data_input = readlines(data)

if (puzzle_part == 1)
    @show catch_the_damn_bus(data_input)
else
    congruences = schedules_to_congruences([ (Δt-1, parse(Int, bus_id)) for (Δt, bus_id) in enumerate(split(data_input[2], ",")) if bus_id != "x" ])
    @show foldl(solve_congruence_system, congruences)
end