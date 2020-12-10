function execute_program(instructions_values)
    is_loop_detected = false

    infinite_loop_for_days = true
    index = 1
    accumulator = 0

    n_instructions = size(instructions_values, 1)
    has_executed = falses(n_instructions)
    while infinite_loop_for_days
        instruction, value = instructions_values[index]

        if (has_executed[index] == true)
            is_loop_detected = true
            break
        end

        has_executed[index] = true

        if (instruction == jump)
            index += parse(Int, value)
        elseif (instruction == accumulate)
            accumulator += parse(Int, value)
            index += 1
        else
            index += 1
        end

        if (index > n_instructions)
            is_loop_detected = false
            break
        end
    end
    
    return accumulator, is_loop_detected
end

function modify_instructions(instructions, instruction_positions, new_instruction)
    for (index, possibly_instruction) ∈ enumerate(instruction_positions)
        if (!possibly_instruction)
            continue
        end

        new_instructions_values = deepcopy(instructions)
        new_instructions_values[index][1] = new_instruction
        accumulator, is_loop_detected = execute_program(new_instructions_values)

        if (!is_loop_detected)
            return accumulator
        end
    end

    return nothing
end

function fix_infinite_loop(instructions_values, puzzle_part)
    instructions = [instruction for (instruction, _) in instructions_values]

    if (puzzle_part == 1)
        return execute_program(instructions_values)[1]
    else
        noops = instructions .== noop
        jumps = instructions .== jump
    
        accumulator = modify_instructions(instructions_values, noops, jump)
        if (accumulator !== nothing)
            return accumulator
        end
        
        return modify_instructions(instructions_values, jumps, noop)
    end
end

jump = "jmp"
accumulate = "acc"
noop = "nop"

# data = "resources/08122020/test.txt"
data = "resources/08122020/input.txt"
puzzle_part = 2

instructions_values = split.(readlines(data), r"\s")

@show fix_infinite_loop(instructions_values, puzzle_part)