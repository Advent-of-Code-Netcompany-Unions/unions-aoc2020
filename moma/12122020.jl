mutable struct Ship
    location::Complex{Int64}
    direction::Tuple{Float64, Float64}
    waypoint::Complex{Int64}
end

function extract_instructions(data_input)::Array{Tuple{String, Int64}, 1}
    instructions = Array{Tuple{String, Int64}, 1}(undef, size(data_input, 1))
    for (idx, input) ∈ enumerate(data_input)
        m = match(r"(?<action>\w)(?<amount>\d+)", input)
        instructions[idx] = (m[:action], parse(Int64, m[:amount]))
    end

    return instructions
end

function simple_ship(ship::Ship, action::String, amount::Int64)::Ship
    if (action in ["N", "S", "E",  "W"])
        local γ
        if (action == "N")
            γ = 0 + 1im
        elseif (action == "S")
            γ = 0 - 1im
        elseif (action == "E")
            γ = 1 + 0im
        else
            γ = -1 + 0im
        end
        ship.location += γ * amount
    elseif (action in ["L", "R"])
        θ = atand(ship.direction[2] / ship.direction[1])
        left_or_right = acosd(ship.direction[1])
        θ = θ == 0 ? left_or_right : θ        
        sign = action == "L" ? 1 : -1
        ship.direction = (cosd(θ + sign * amount), sind(θ + sign * amount))
    else
        ship.location += amount * (ship.direction[1] + ship.direction[2]im)
    end

    return ship
end

function waypoint_ship(ship::Ship, action::String, amount::Int64)::Ship
    if (action in ["N", "S", "E",  "W"])
        local γ
        if (action == "N")
            γ = 0 + 1im
        elseif (action == "S")
            γ = 0 - 1im
        elseif (action == "E")
            γ = 1 + 0im
        else
            γ = -1 + 0im
        end
        ship.waypoint += γ * amount
    elseif (action in ["L", "R"])
        sign = action == "L" ? 1 : -1
        ship.waypoint = ship.waypoint * (cosd(sign * amount) + sind(sign * amount)im)
    else
        ship.location += amount * ship.waypoint
    end

    return ship
end

function apply_instruction(instruction::Tuple{String, Int64}, ship::Ship, puzzle_part::Int64)::Ship
    action = instruction[1]
    amount = instruction[2]

    if (puzzle_part == 1)
        return simple_ship(ship, action, amount)
    else
        return waypoint_ship(ship, action, amount)
    end
end

function avoid_the_iceberg(data_input, puzzle_part)
    navigational_instructions = extract_instructions(data_input)

    ship = Ship(0 + 0im, (1, 0), (10 + 1im))
    for instruction ∈ navigational_instructions
        ship = apply_instruction(instruction, ship, puzzle_part)
    end
    
    return abs(real(ship.location)) + abs(imag(ship.location))
end

# data = "resources/12122020/test.txt"
data = "resources/12122020/input.txt"
puzzle_part = 2
data_input = readlines(data)

@show avoid_the_iceberg(data_input, puzzle_part)