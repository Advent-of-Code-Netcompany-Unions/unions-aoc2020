function is_outside_bounds(y::Int, y_limit::Int)::Bool
    return y > y_limit
end

function increment_coordinates(x::Int, x_inc::Int, x_limit::Int, y::Int, y_inc::Int)::Tuple{Int, Int}
    return (mod1(x + x_inc, x_limit), y + y_inc)
end

function traverse_map(map, x_inc::Int, y_inc::Int)::Int
    y_limit, x_limit = size(map)

    is_tree = map .== "#"
    trees_hit = 0
    x_coordinate, y_coordinate = (1, 1)
    while true
        if is_outside_bounds(y_coordinate, y_limit)
            @show y_coordinate, trees_hit
            break
        end
    
        trees_hit += is_tree[y_coordinate, x_coordinate] ? 1 : 0
        x_coordinate, y_coordinate = increment_coordinates(x_coordinate, x_inc, x_limit, y_coordinate, y_inc)
    end
    
    return trees_hit
end

# data = "resources/03122020/test.txt"
data = "resources/03122020/input.txt"

slopes = [1 1; 3 1; 5 1; 7 1; 1 2]
trees_hit = zeros(size(slopes)[1])

map = permutedims(hcat(split.(readlines(data), r"")...))
for (index, slope) in enumerate(eachrow(slopes))
    trees_hit[index] = traverse_map(map, slope[1], slope[2])
end

@show cumprod(trees_hit)[end]