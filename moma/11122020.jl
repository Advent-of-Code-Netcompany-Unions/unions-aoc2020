function simple_sheeple(row, col, seating_plan)
    neighbours = [ seating_plan[i, j] == OCCUPIED_SEAT for i = row-1:row+1, j = col-1:col+1 if !(i == row && j == col) ]
    return cumsum(neighbours)[end]
end

function neighbour_sheeple(row::Int64, col::Int64, row_lim::Int64, col_lim::Int64, seating_plan::Array{SubString{String}, 2}, puzzle_part::Int64)::Int64
    if (puzzle_part == 1)
        return simple_sheeple(row, col, seating_plan)
    else
        return advanced_sheeple(row, col, row_lim, col_lim, seating_plan)
    end
end

function is_inside_boundary(row, col, row_lim, col_lim)
    return row >= 1 && col >= 1 &&
        row <= row_lim && col <= col_lim    
end

function advanced_sheeple(row::Int64, col::Int64, row_lim::Int64, col_lim::Int64, sheeple_layout)
    directions = [(-1, -1), (-1, 0), (-1, 1), (0, 1), (1, 1), (1, 0), (1, -1), (0, -1)]
    neighbour_sheeples = 0
    for (row_inc, col_inc) ∈ directions
        neighbour_sheeples += walk_the_sheeple(row, col, row_inc, col_inc, row_lim, col_lim, sheeple_layout)
    end
    
    return neighbour_sheeples    
end

function walk_the_sheeple(row, col, row_inc, col_inc, row_lim, col_lim, sheeple_layout)
    k = 0
    while true
        k += 1
        i, j = (row + row_inc * k, col + col_inc * k) 

        if (!is_inside_boundary(i, j, row_lim, col_lim))
            return 0
        end

        sheeple_seat = sheeple_layout[i, j]

        if (sheeple_seat == FLOOR_SPACE)
            continue
        elseif (sheeple_seat == EMPTY_SEAT)
            return 0
        else
            return 1
        end
    end    
end

function sheeple_snapshot(sheeple_layout, puzzle_part)::Tuple{Bool, Array{SubString{String}, 2}}
    row_lim, col_lim = size(sheeple_layout)
    sheeple_limit = puzzle_part == 1 ? 4 : 5
    sheeple_moved = false
    previous_sheeple_layout = deepcopy(sheeple_layout)
    for i = 1:row_lim
        for j = 1:col_lim
            current_seat = previous_sheeple_layout[i, j]

            if (current_seat == FLOOR_SPACE)
                continue
            end
    
            sheeple = neighbour_sheeple(i, j, row_lim, col_lim, previous_sheeple_layout, puzzle_part)
            if (current_seat == EMPTY_SEAT && sheeple == 0)
                sheeple_layout[i, j] = OCCUPIED_SEAT
                sheeple_moved = true
            elseif (current_seat == OCCUPIED_SEAT && sheeple >= sheeple_limit)
                sheeple_layout[i, j] = EMPTY_SEAT
                sheeple_moved = true
            end
        end
    end

    return (sheeple_moved, sheeple_layout)
end

function predict_sheeple_sitting_pattern(seating_plan::Array{SubString{String}, 2}, puzzle_part::Int64)
    sheeple_still_moving = true
    while sheeple_still_moving
        state_changed, seating_plan = sheeple_snapshot(seating_plan, puzzle_part)
        
        if (!state_changed)
            return cumsum(sum(x -> x == OCCUPIED_SEAT, seating_plan, dims=1), dims=2)[end]
        end
    end
end

FLOOR_SPACE = "."
EMPTY_SEAT = "L"
OCCUPIED_SEAT = "#"

# data = "resources/11122020/test.txt"
data = "resources/11122020/input.txt"
puzzle_part = 2
seating_plan = permutedims(hcat(split.(readlines(data), r"")...))

@show predict_sheeple_sitting_pattern(seating_plan, puzzle_part)