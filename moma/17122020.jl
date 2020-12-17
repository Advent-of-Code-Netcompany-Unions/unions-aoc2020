struct Cell{T<:Integer}
    x::T
    y::T
    z::T
    w::T
end

function parse_input(input::Array{SubString{String}})::Dict{Cell,Int64}
    z, w = (0, 0)
    xmax, ymax = size(input)
    parsed = Dict{Cell,Int64}()
    for x ∈ range(1; stop=xmax)
        for y ∈ range(1; stop=ymax)
            if (input[x,y] == "#")
                parsed[Cell(x,y,z,w)] = 1
            end
        end
    end

    return parsed
end

function check_cell_neighbours!(cell::Cell, pocket_dimension::Dict{Cell,Int64}, updated_dimension::Dict{Cell,Int64})
    for x ∈ cell.x-1:cell.x+1
        for y ∈ cell.y-1:cell.y+1
            for z ∈ cell.z-1:cell.z+1
                for w ∈ cell.w-1:cell.w+1
                    current_cell = Cell(x,y,z,w)
                    
                    current_state = get(pocket_dimension, current_cell, 0)
                    count_alive_neighbours = count_all_alive_neighbours(current_cell, pocket_dimension)
                    if (current_state == 0 && count_alive_neighbours == 3)
                        updated_dimension[current_cell] = 1
                    elseif (current_state == 1 && !(count_alive_neighbours == 2 || count_alive_neighbours == 3))
                        delete!(updated_dimension, current_cell)
                    end
                end
            end
        end
    end
end

function count_all_alive_neighbours(cell::Cell, dimension::Dict{Cell,Int64})::Integer
    return sum([get(dimension, Cell(x,y,z,w), 0) for x=cell.x-1:cell.x+1, y=cell.y-1:cell.y+1, z=cell.z-1:cell.z+1, w=cell.w-1:cell.w+1 if Cell(x,y,z,w) != cell])
end

function evolve(pocket_dimension::Dict{Cell,Int64})::Dict{Cell,Int64}
    updated_dimension = deepcopy(pocket_dimension)
    for alive_cell ∈ keys(pocket_dimension)
        check_cell_neighbours!(alive_cell, pocket_dimension, updated_dimension)
    end

    return updated_dimension
end

function find_the_conway_cubes(input::Array{SubString{String}})::Integer
    evolution_limit = 6
    pocket_dimension = parse_input(input)

    evolution_step = 1

    while (evolution_step <= evolution_limit)
        pocket_dimension = evolve(pocket_dimension)
        evolution_step += 1
    end
    
    return size(collect(keys(pocket_dimension)), 1)
end

# data = "resources/17122020/test.txt"
data = "resources/17122020/input.txt"

data_input = permutedims(hcat(split.(readlines(data), r"")...))

@show find_the_conway_cubes(data_input)