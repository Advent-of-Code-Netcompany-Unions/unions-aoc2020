function get_element(constituents::Array{String}, counter::Integer)
    elem = constituents[counter]
    counter += 1
    return (elem, counter)
end

# should probably just remove this method and generalize the other a tiny bit, but ¯\_(ツ)_/¯
function evaluate_expression(constituents::Array{String}, counter::Integer = 1)::Tuple{Integer, Integer}
    lhs, counter = get_element(constituents, counter)
    if (lhs == "(")
        lhs, counter = evaluate_expression(constituents, counter)
    end
    if (typeof(lhs) == String)
        lhs = parse(Int, lhs)
    end

    while (counter < size(constituents, 1))
        if (constituents[counter] == ")")
            counter += 1
            break
        end

        operator, counter = get_element(constituents, counter)
        rhs, counter = get_element(constituents, counter)
        if (rhs == "(")
            rhs, counter = evaluate_expression(constituents, counter)
        end

        if (typeof(rhs) == String)
            rhs = parse(Int, rhs)
        end

        local result
        if (operator == "+")
            result = lhs + rhs
        elseif (operator == "*")
            result = lhs * rhs
        else
            throw(DomainError("operator must be + or *"))
        end
        lhs = result
    end

    return (lhs, counter)
end

function simple_maths(constituents::Array{String})::Integer
    return evaluate_expression(constituents)[1]
end

function evaluate_advanced_expression(constituents::Array{String}, counter::Integer = 1, is_inside_parenthesis::Bool = false)::Tuple{Integer, Integer}
    lhs, counter = get_element(constituents, counter)
    if (lhs == "(")
        lhs, counter = evaluate_advanced_expression(constituents, counter, true)
    end
    if (typeof(lhs) == String)
        lhs = parse(Int, lhs)
    end

    while (counter < size(constituents, 1))
        if (constituents[counter] == ")")
            if (is_inside_parenthesis)
                counter += 1
            end
            break
        end

        operator, counter = get_element(constituents, counter)

        local rhs
        if (operator == "*")
            rhs, counter = evaluate_advanced_expression(constituents, counter)
        else
            rhs, counter = get_element(constituents, counter)
            if (rhs == "(")
                rhs, counter = evaluate_advanced_expression(constituents, counter, true)
            end
        end

        if (typeof(rhs) == String)
            rhs = parse(Int, rhs)
        end

        local result
        if (operator == "+")
            result = lhs + rhs
        elseif (operator == "*")
            result = lhs * rhs
        else
            throw(DomainError("operator must be + or *"))
        end
        lhs = result
    end

    return (lhs, counter)
end

function advanced_maths(expression)
    return evaluate_advanced_expression(expression)[1]
end

function solve_the_maths(maths_expressions::Array{String, 1}, puzzle_part::Integer)::BigInt
    results = zeros(Integer, size(maths_expressions, 1))
    for (idx, expression) ∈ enumerate(maths_expressions)
        constituents = collect(String, Iterators.flatten(split.(split(expression, r"\s"), "")))
        if (puzzle_part == 1)
            results[idx] = simple_maths(constituents)
        else
            results[idx] = advanced_maths(constituents)
        end
    end

    return foldl(+, results)
end

# data = "resources/18122020/test.txt"
data = "resources/18122020/input.txt"

data_input = readlines(data)
puzzle_part = 2

@show solve_the_maths(data_input, puzzle_part)