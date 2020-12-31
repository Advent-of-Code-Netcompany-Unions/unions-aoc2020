function find_loop_size(pub_key::Int, subject_number::Int = 7, n::Int = 20201227)::Int
    value, loop_size = (1, 0)    
    while value != pub_key
        loop_size += 1
        value = mod(value * subject_number, n)
    end
    return loop_size
end

function encryption_key(loop_size::Int, subject_number::Int = 7, n::Int = 20201227)
    value = 1
    for i ∈ 1:loop_size
        value = mod(value * subject_number, n)
    end
    return value
end

function hack_rfid_card(input::String)::Int
    card_pub_key, door_pub_key = parse.(Int, split(input, "\n"))

    card_loop_size = find_loop_size(card_pub_key)
    door_loop_size = find_loop_size(door_pub_key)

    return encryption_key(card_loop_size, door_pub_key)
end

function main()
    curr_day = string(split(split(@__FILE__, "/")[end], ".jl"; keepempty=false)[1])
    # data = "$(@__DIR__)/resources/$curr_day/test.txt"
    data = "$(@__DIR__)/resources/$curr_day/input.txt"

    str = read(open(data), String)

    @show hack_rfid_card(str)
end

main()