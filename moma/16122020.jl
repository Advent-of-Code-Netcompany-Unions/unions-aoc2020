struct ValidationRule{T<:Integer}
    lower_bound::T
    upper_bound::T
end

struct Validation{T<:String, U<:ValidationRule}
    name::T
    rule_a::U
    rule_b::U
end

function parse_rules(rules_str::SubString{String})
    rules_regex = r"^(?<rule_name>[\w\s]+):\s(?<min_a>\d+)-(?<max_a>\d+)\sor\s(?<min_b>\d+)-(?<max_b>\d+)$"
    rules_input = split(rules_str, "\n")::Array{SubString{String}, 1}

    validations = Array{Validation, 1}(undef, size(rules_input, 1))
    for (idx, rule) ∈ enumerate(rules_input)
        m = match(rules_regex, rule)
        rule_a = ValidationRule(parse(Int, m[:min_a]), parse(Int, m[:max_a]))
        rule_b = ValidationRule(parse(Int, m[:min_b]), parse(Int, m[:max_b]))
        validations[idx] = Validation(string(m[:rule_name]), rule_a, rule_b)
    end

    return validations    
end

function parse_input(input::Array{SubString{String}})::Tuple{Array{Validation, 1}, Array{Integer, 1}, Array{Integer, 2}}
    validation_rules = parse_rules(input[1])
    own_ticket = parse.(Int, split(split(input[2], "\n")[2], ","))
    nearby_tickets = parse.(Int, permutedims(hcat(split.(split(split(input[3], ":\n")[2], "\n"), ",")...)))

    return (validation_rules, own_ticket, nearby_tickets)
end

function calculate_error_rate(validation_rules::Array{Validation, 1}, nearby_tickets::Array{Integer, 2})::Tuple{Integer, Array{Integer, 2}}
    error_rate = 0
    tickets, fields_per_ticket = size(nearby_tickets)
    rules = size(validation_rules, 1)
    valid_nearby_tickets = zeros(Integer, 0, fields_per_ticket)
    for (ticket_idx, ticket) ∈ enumerate(eachrow(nearby_tickets))
        validation_array = falses(rules, fields_per_ticket)
        for (rule_idx, validation_rule) ∈ enumerate(validation_rules)
            rule_a = validation_rule.rule_a.lower_bound .<= ticket .<= validation_rule.rule_a.upper_bound
            rule_b = validation_rule.rule_b.lower_bound .<= ticket .<= validation_rule.rule_b.upper_bound
            validation_array[rule_idx, :] = rule_a .+ rule_b
        end

        is_valid = true
        for (ticket_field, validation_entry) ∈ enumerate(eachcol(validation_array))
            valid = sum(validation_entry)
            if (valid == 0)
                is_valid = false
                error_rate += ticket[ticket_field]
            end
        end

        if (is_valid)
            valid_nearby_tickets = [valid_nearby_tickets; ticket']
        end
    end
    
    return (error_rate, valid_nearby_tickets)
end

function stuff(validation_rules::Array{Validation, 1}, own_ticket::Array{Integer, 1}, nearby_tickets::Array{Integer, 2})::Integer
    _, valid_nearby_tickets = calculate_error_rate(validation_rules, nearby_tickets)

    tickets, fields_per_ticket = size(valid_nearby_tickets)
    rules = size(validation_rules, 1)

    validation_array = zeros(Integer, rules, fields_per_ticket)
    field_to_rule = repeat(validation_rules)
    for (ticket_idx, ticket) ∈ enumerate(eachrow(valid_nearby_tickets))
        # validation_array = falses(rules, fields_per_ticket)
        for (rule_idx, validation_rule) ∈ enumerate(validation_rules)
            rule_a = validation_rule.rule_a.lower_bound .<= ticket .<= validation_rule.rule_a.upper_bound
            rule_b = validation_rule.rule_b.lower_bound .<= ticket .<= validation_rule.rule_b.upper_bound
            validation_array[rule_idx, :] += rule_a .+ rule_b
        end
    end


    # s = sum(t; dims=2)
    # sorted_rules = Array{Tuple{String, Integer, BitArray{1}}, 1}()


    # show(stdout, MIME"text/plain"(), validation_rules)
    # println()
    # show(stdout, MIME"text/plain"(), validation_array)
    # println()

    rule_indices = falses(rules, fields_per_ticket)
    valid_rules_for_field = zeros(Integer, fields_per_ticket)
    valid_fields_for_rule = zeros(Integer, rules)
    for (idx, col) in enumerate(eachcol(validation_array))
        valid_rules_for_field[idx] = sum(col .== tickets)
    end
    for (idx, row) in enumerate(eachrow(validation_array))
        valid_fields_for_rule[idx] = sum(row .== tickets)
    end



    # valid_rules_for_field = sum(rule_indices; dims=1)

    # FIXME: fix rule/field sorting
    field_order = sortperm(valid_rules_for_field; rev=true)
    rule_order = sortperm(valid_fields_for_rule; rev=true)

    @show field_order
    @show rule_order
    # show(stdout, MIME"text/plain"(), validation_rules[rule_order])
    sorted_fields = own_ticket[field_order]
    sorted_rules = validation_rules[rule_order]
    ticket_value = 1
    for (rule_idx, rule) ∈ enumerate(sorted_rules)
        if (startswith(rule.name, "departure"))
            # @show rule.name, rule_idx
            @show rule_idx
            @show own_ticket[rule_idx]
            ticket_value *= own_ticket[rule_idx]
        end
    end

    # show(stdout, MIME"text/plain"(), rule_indices)
    # println()
    # show(stdout, MIME"text/plain"(), valid_rules_for_field)
    # println()
    # @show tickets

    # rule_to_field = Dict{Integer, Integer}()
    # cnt = 0
    # remaining_rules = 20
    # while (true && cnt <= 100)

        
    #     cnt += 1
    # end

    return ticket_value
end

function hack_the_foreign_language(input::Array{SubString{String}}, puzzle_part::Int)
    validation_rules, own_ticket, nearby_tickets = parse_input(input)

    if (puzzle_part == 1)
        error_rate, _ = calculate_error_rate(validation_rules, nearby_tickets)
        return error_rate
    else
        return stuff(validation_rules, own_ticket, nearby_tickets)
    end
    
end

# data = "resources/16122020/testa.txt"
# data = "resources/16122020/testb.txt"
data = "resources/16122020/input.txt"

puzzle_part = 2
data_input = split(read(data, String), "\n\n")

@show hack_the_foreign_language(data_input, puzzle_part)