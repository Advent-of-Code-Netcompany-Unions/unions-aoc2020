struct Tile{T<:Int}
    x::T
    y::T
    z::T
end

function get_direction_increments(direction::String)::Tuple{Int, Int, Int}
    east = (1, -1, 0)
    southeast = (0, -1, 1)
    southwest = (-1, 0, 1)
    if (direction == "e")
        return east
    elseif (direction == "se")
        return southeast
    elseif (direction == "sw")
        return southwest
    elseif (direction == "w")
        return -1 .* east
    elseif (direction == "nw")
        return -1 .* southeast
    elseif (direction == "ne")
        return -1 .* southwest
    else
        throw(DomainError("wtf you doin fam"))
    end
end

function flip_tile(instructions::String)::Tile
    instr_pntr = 1
    p = (0,0,0)
    while instr_pntr <= length(instructions)
        increment = 1

        direction = instructions[instr_pntr:instr_pntr]        
        if (direction in ["s", "n"])
            direction = instructions[instr_pntr:instr_pntr+1]
            increment = 2
        end

        p = p .+ get_direction_increments(direction)

        instr_pntr += increment
    end

    return Tile(p...)
end

function place_tiles(input::String)::Dict{Tile, Int}
    tiles = Dict{Tile, Int}()
    for tile_instruction ∈ split(input,  "\n")
        tile = flip_tile(string(tile_instruction))
        if (haskey(tiles, tile))
            delete!(tiles, tile)
        else
            tiles[tile] = 1
        end
    end

    return tiles
end

count_black_neighbours(tile::Tile, layout::Dict{Tile,Int}) = sum([get(layout, Tile(x,y,z), 0) for x=tile.x-1:tile.x+1, y=tile.y-1:tile.y+1, z=tile.z-1:tile.z+1 if Tile(x,y,z) != tile && x+y+z == 0])

function check_tile_neighbours!(tile::Tile, current_layout::Dict{Tile,Int}, new_layout::Dict{Tile,Int})
    for x ∈ tile.x-1:tile.x+1
        for y ∈ tile.y-1:tile.y+1
            for z ∈ tile.z-1:tile.z+1
                if (x+y+z != 0)
                    continue
                end
                current_tile = Tile(x,y,z)
                    
                current_state = get(current_layout, current_tile, 0)
                black_neighbours = count_black_neighbours(current_tile, current_layout)
                if (current_state == 0 && black_neighbours == 2)
                    new_layout[current_tile] = 1
                elseif (current_state == 1 && (black_neighbours == 0 || black_neighbours > 2))
                    delete!(new_layout, current_tile)
                end
            end
        end
    end
end

function perform_christmas_miracle(tiles::Dict{Tile, Int})::Dict{Tile, Int}
    updated_tiles = deepcopy(tiles)

    for tile ∈ keys(tiles)
        check_tile_neighbours!(tile, tiles, updated_tiles)
    end

    return updated_tiles
end

function bring_the_tiles_back_to_life(tiles::Dict{Tile, Int}, days::Int)::Int
    for day ∈ 1:days
        tiles = perform_christmas_miracle(tiles)
    end
    
    return size(collect(keys(tiles)),1)
end

function fix_lobby(input::String, puzzle_part::Int)::Int
    if (puzzle_part == 1)
        return size(collect(place_tiles(input)),1)
    else
        return bring_the_tiles_back_to_life(place_tiles(input), 100)
    end
end

function main()
    curr_day = string(split(split(@__FILE__, "/")[end], ".jl"; keepempty=false)[1])
    # data = "$(@__DIR__)/resources/$curr_day/test.txt"
    data = "$(@__DIR__)/resources/$curr_day/input.txt"

    str = read(open(data), String)
    puzzle_part = 2

    @show fix_lobby(str, puzzle_part)
end

main()