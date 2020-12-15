struct Mask
    mask::String
    ones::Array{UnitRange{Int64}, 1}
    zeros::Array{UnitRange{Int64}, 1}
    floating::Array{UnitRange{Int64}, 1}
    Mask(mask) = new(mask, findall("1", mask), findall("0", mask), findall("X", mask))
end

function apply_simple_mask(decimal_value::Int, mask::Mask)::String
    binary_value = collect(string(decimal_value; base = 2, pad=MEMORY_SIZE))

    for one_idx ∈ mask.ones
        binary_value[one_idx] .= '1'
    end

    for zero_idx ∈ mask.zeros
        binary_value[zero_idx] .= '0'
    end

    return join(binary_value)
end

function generate_floating_values(memory::Dict{Int, String}, memory_value::Array{Char, 1}, decimal_value::Int)
    floaties = memory_value .== 'X'
    floatie_limit = sum(floaties)
    all_binary_combinations = [ string(x; base=2, pad=floatie_limit) for x in range(0; stop=2^floatie_limit-1)]
    for binary_combination ∈ all_binary_combinations
        binary_arr = collect(binary_combination)

        temp_address = deepcopy(memory_value)
        temp_address[floaties] = binary_arr

        address = parse(Int, join(temp_address); base = 2)
        memory[address] = string(decimal_value; base = 2)
    end

    return memory
end

function apply_out_of_control_mask(decimal_value::Int, memory_address::Int, mask::Mask, memory::Dict{Int, String})::Dict{Int, String}
    t = string(memory_address; base = 2, pad=MEMORY_SIZE)
    binary_value = collect(string(memory_address; base = 2, pad=MEMORY_SIZE))

    for one_idx ∈ mask.ones
        binary_value[one_idx] .= '1'
    end

    for floating_idx ∈ mask.floating
        binary_value[floating_idx] .= 'X'
    end

    return generate_floating_values(memory, binary_value, decimal_value)
end

function apply_instruction(instruction::String, mask::Mask, memory::Dict{Int, String}, puzzle_part::Int)::Dict{Int, String}
    memory_address, decimal_value = parse.(Int, match(MEMORY_REGEX, instruction).captures)
    if (puzzle_part == 1)
        memory[memory_address] = apply_simple_mask(decimal_value, mask)
    else
        memory = apply_out_of_control_mask(decimal_value, memory_address, mask, memory)
    end
    
    return memory
end

function initialize_docking(program::Array{String, 1}, puzzle_part::Int)
    memory = Dict{Int, String}()
    mask = Mask(program[1][8:end])
    for instruction ∈ program[2:end]
        if (startswith(instruction, "mask"))
            mask = Mask(instruction[8:end])
            continue
        end

        memory = apply_instruction(instruction, mask, memory, puzzle_part)
    end

    return cumsum(parse.(Int, values(memory); base=2))[end]
end

# data = "resources/14122020/testa.txt"
# data = "resources/14122020/testb.txt"
data = "resources/14122020/input.txt"

puzzle_part = 2
data_input = readlines(data)

MEMORY_SIZE = 36
MEMORY_REGEX = r"^mem\[(?<memory_address>\d+)\]\s=\s(?<decimal_value>\d+)$"

@show initialize_docking(data_input, puzzle_part)