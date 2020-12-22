function get_decks(input::String)
    players = Dict{Int, Array{Int,  1}}()
    for raw_player ∈ split(input, "\n\n")
        player_id = parse(Int, raw_player[8:8])
        players[player_id] = parse.(Int, split(raw_player[11:end], "\n"))
    end
    
    return players[1], players[2]
end

score(winning_player::Array{Int, 1}) = sum([idx * val for (idx, val) in enumerate(reverse(winning_player))])

function play(player1::Array{Int, 1}, player2::Array{Int, 1})::Int
    while true
        c1 = popfirst!(player1)
        c2 = popfirst!(player2)

        if (c1 > c2)
            append!(player1, [c1, c2])
        elseif  (c1 < c2)
            append!(player2, [c2, c1])
        else
            throw(DomainError("Not sure if this is supposed to happen??"))
        end

        if (isempty(player1) || isempty(player2))
            break
        end
    end

    return isempty(player1) ? score(player2) : score(player1)
end

function configuration_seen(memory::Array{Array{Int, 1}, 1}, player1::Array{Int, 1}, player2::Array{Int, 1})::Bool
    # subtract 2 from upper limit to range as this is the current game configuration
    for game_id ∈ range(1; step=2, stop=size(memory, 1)-2)
        if (memory[game_id] == player1 && memory[game_id+1] == player2)
            return true
        end
    end

    return false
end

@doc "Returns true if p1 wins, false otherwise."
function recursive_play(player1::Array{Int, 1}, player2::Array{Int, 1})::Bool
    game_memory = Array{Array{Int, 1}, 1}()

    while true
        append!(game_memory, [deepcopy(player1), deepcopy(player2)])
        p1_wins = false
        is_recurse_round = false
        if (configuration_seen(game_memory, player1, player2))
            return true
        end
        c1 = popfirst!(player1)
        c2 = popfirst!(player2)

        if (c1 <= size(player1, 1) && c2 <= size(player2, 1))
            is_recurse_round = true
            p1_wins = recursive_play(deepcopy(player1[range(1; length=c1)]), deepcopy(player2[range(1; length=c2)]))
        end

        if (!is_recurse_round)
            p1_wins = c1 > c2
        end

        if (p1_wins)
            append!(player1, [c1, c2])
        else
            append!(player2, [c2, c1])
        end

        if (isempty(player1) || isempty(player2))
            break
        end
    end

    return isempty(player2)
end

function all_hail_the_crabigator(input::String, puzzle_part::Int)::Int
    p1, p2 = get_decks(input)

    if (puzzle_part == 1)
        return play(p1, p2)
    else
        p1_won = recursive_play(p1, p2)
        return p1_won ? score(p1) : score(p2)
    end
end

# data = "resources/22122020/test.txt"
data = "resources/22122020/input.txt"

str = read(open(data), String)
puzzle_part = 2

@show all_hail_the_crabigator(str, puzzle_part)