function parse_tiles(input::String)::Dict{Int, Matrix{Char}}
    tiles = Dict{Int, Matrix{Char}}()
    for raw_tile ∈ split(input, "\n\n")
        # first line of tile is always 'Tile NNNN:'
        tile_id = parse(Int, raw_tile[6:9])
        tiles[tile_id] = Matrix{Char}(undef, 10, 10)
        for x ∈ 1:10, y ∈ 1:10
            # first 11 characters is tile metadata. x runs through each column and y chooses the row
            tiles[tile_id][x, y] = raw_tile[x + 11y]
        end
    end

    return tiles
end

@doc "Rotates and flips (i < 0) tile counter-clockwise by an amount i * 90 degrees"
rotate_and_flip(tile::Matrix{Char}, i::Int) = i >= 0 ? rotl90(tile, i) : rotl90(reverse(tile, dims=1), i)

@doc "Checks if the tiles[state1[1]] lower side matches the tiles[state2[1]] upper side"
tiles_match_up_down(tiles::Dict{Int, Matrix{Char}}, state1::Tuple{Int, Int}, state2::Tuple{Int, Int}) = rotate_and_flip(tiles[state1[1]], state1[2])[end, :] == rotate_and_flip(tiles[state2[1]], state2[2])[1, :]

@doc "Checks if the tiles[state1[1]] right side matches the tiles[state2[1]] left side"
tiles_match_left_right(tiles::Dict{Int, Matrix{Char}}, state1::Tuple{Int, Int}, state2::Tuple{Int, Int}) = rotate_and_flip(tiles[state1[1]], state1[2])[:, end] == rotate_and_flip(tiles[state2[1]], state2[2])[:, 1]

@doc "Check if we're moving along the top-most row. If not then check if the top of this row matches the bottom of the previous row in the same column"
is_top_row_or_left_right_sides_match(tiles::Dict{Int, Matrix{Char}}, state::Array{Tuple{Int, Int}, 2}, x::Int, y::Int) = y == 1 || tiles_match_up_down(tiles, state[x, y - 1], state[x, y])

@doc "Check if we're moving along the left-most column. If not then check if the left of this column matches the right of the previous column in the same row"
is_top_column_or_top_bottom_sides_match(tiles::Dict{Int, Matrix{Char}}, state::Array{Tuple{Int, Int}, 2}, x::Int, y::Int) = x == 1 || tiles_match_left_right(tiles, state[x - 1, y], state[x, y])

@doc "Check if we've reached the lower right tile of our image"
is_in_lower_right_tile(state::Array{Tuple{Int, Int}, 2}, x::Int, y::Int) = (x, y) == size(state)

@doc "Recursive method for populating the image with tiles. Defaults to starting in the corner (x,y) = (1, 1)" ->
function populate!(tiles::Dict{Int, Matrix{Char}}, state::Array{Tuple{Int, Int}, 2}, x::Int = 1, y::Int = 1)::Bool
    # first we generate the set difference between all available tile IDs and the tile IDs currently in our image ensuring we only look at unplaced tiles.
    # i is a rotation iterator ensuring we compare all possible combinations for each tile
    for k ∈ setdiff(keys(tiles), first.(state)), i ∈ -4:3
        state[x, y] = (k, i)
        # check if we're moving along a) top-most row or current tile matches tile in previous row, same column or b) left-most column or current tile matches tile in previous column, same row
        if (is_top_row_or_left_right_sides_match(tiles, state, x, y) && is_top_column_or_top_bottom_sides_match(tiles, state, x, y))
            # if so, then check if we've filled up the image with tiles, otherwise try and populate the next tile (moving from left to right, then down when reaching the side)
            if (is_in_lower_right_tile(state, x, y) || populate!(tiles, state, mod1(x+1, size(state, 1)), y+(x==size(state, 1))))
                return true
            end
        end
    end

    # unable to match current tile with the surrounding tiles. Resetting tile
    state[x, y] = (0, 0)
    return false
end

function assemble_the_photo(tiles::Dict{Int, Matrix{Char}})::Array{Tuple{Int, Int}, 2}
    # a square image has N² tiles and has dimensions NxN
    N = Int(√length(tiles))

    # image array state. Each entry is a tuple of (tile_id, orientation)
    state = fill((0, 0), N, N);

    populate!(tiles, state)

    return state
end

function FIND_THE_KRAKEN!!!(image::Matrix{Char}, THE_KRAKEN::Array{Char, 2})::Int
    max_monsters_found = 0
    
    # check all orientations of the image
    for i ∈ -4:3
        image_copy = rotate_and_flip(image, i)
        monsters_found = 0

        # run from upper left corner to lower right corner but leaving space for the kraken to the right and the bottom
        for x ∈ 1:size(image_copy, 1) - size(THE_KRAKEN, 1) + 1, y ∈ 1:size(image_copy, 2) - size(THE_KRAKEN, 2) + 1
            # assume we've found the kraken originating from the image pixel (x, y). It is quicker to disprove than to prove we've found the kraken
            found = true

            # check all pixels from (x, y) to (x + u, y + v) with u,v running from 1 to the size of the kraken sub-image
            for u ∈ 1:size(THE_KRAKEN, 1), v ∈ 1:size(THE_KRAKEN, 2)
                if (THE_KRAKEN[u, v] == '#' && image_copy[x + u - 1, y + v - 1] != '#')
                    # as soon as we disprove the assumption of having found the kraken we stop looking from the current pixel (x,y)
                    found = false
                    break
                end
            end
            monsters_found += found
        end

        # for the current orientation did we find more krakens than any other orientation?
        max_monsters_found = max(max_monsters_found, monsters_found)
    end
    
    println("THE KRAKEN HAS BEEN DESTROYED")
    return count(image .== '#') - max_monsters_found * count(THE_KRAKEN  .== '#')
end

function KIIILLLLL_THE_KRAKEN!!!(tiles::Dict{Int, Matrix{Char}}, state::Array{Tuple{Int, Int}, 2})::Int
    println("THE KRAKEN IS AAANGRRRY!!!")
    println("                                                 .")
    println("                                            __._/|_")
    println("                  .                        (__( (_(")
    println("                 /|                   - '. \\'-:)8)-.")
    println("                ( (_..-..          .'     '.'-(_(-'")
    println("       _~_       '-.--.. '.      .'         '  )8)")
    println("    __(__(__     \\      88 \\    /            )(8(        \\.    .")
    println("   (_((_((_(      8\\     88 \\.-'  .-.        )88 :       /\\\\  _X_ __ .")
    println(" \\=-:--:--:--.     8)     88/__) /(e))       88.'        \\#\\\\(__((_//\\   .")
    println("_,\\_o__o__o__/,__(8(_,__,_'.'--' '--' _    _88.'..___,___,\\_,,,|/_(Y(/__,__,___,___")
    println("            \\    '._''--..'-/88 ) 88)(8  \\\\  \\              \\w\\_   /X/")
    println("             8\\ __.--''_--'( 8 ( 8/    88( )8 )              -' ' __")
    println("              '8888--''     \\ 8  \\88   88| 88(                   /_/")
    println("                            )88  (88   ) )  88\\                 _ '")
    println("                           ( 8    )88 ( (    88\\               /V")
    println("                            )8)   (8\\'-8 )-   '8'.__ _")
    println("                            //     \\8 '-//--'   '88-8-.-'           H")
    println("                           ((     ((   ))")
    println("                            \\      \\   (    X")
    println("                                                                   Y")
    println("                                     X   __")
    println("                                        )_/  /\\")
    println("                                         '  /W/")
    println("                                            \\|")
    
    THE_KRAKEN =
        "..................#." *
        "#....##....##....###" *
        ".#..#..#..#..#..#...";

    THE_KRAKEN = reshape(collect(THE_KRAKEN),(20,3));

    # a square image has N² tiles and has dimensions NxN
    N = Int(√length(tiles))

    image = Matrix{Char}(undef, 8N, 8N)
    for x ∈ 1:N, y ∈ 1:N
        t = rotate_and_flip(tiles[state[x, y][1]], state[x, y][2])
        range_x = range(1 + 8(x-1); stop=8 + 8(x-1))
        range_y = range(1 + 8(y-1); stop=8 + 8(y-1))
        # save transposed tile in image
        image[range_x, range_y] = permutedims(t[2:end-1, 2:end-1])
    end

    return FIND_THE_KRAKEN!!!(image, THE_KRAKEN)
end

function mass_surveillance_COMMENCE(input::String, puzzle_part::Int)::Int
    tiles = parse_tiles(input)

    state = assemble_the_photo(tiles)

    if (puzzle_part == 1)
        # state[[1, end], [1, end]] picks out the four corner tiles
        # first.() takes the first entry in the tuple
        # prod() multiplies each element from the iterator
        return prod(first.(state[[1,end],[1,end]]))
    else
        return KIIILLLLL_THE_KRAKEN!!!(tiles, state)
    end
end

# data = "resources/20122020/test.txt"
data = "resources/20122020/input.txt"

str = read(open(data), String)
puzzle_part = 2

@show mass_surveillance_COMMENCE(str, puzzle_part)