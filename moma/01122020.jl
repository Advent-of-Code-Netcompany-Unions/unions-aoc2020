using Combinatorics

function find_expense_meeting_cutoff_value(combinations::Base.Generator, cutoff::Int)::Tuple{Int, Array{Int, 1}}
    for i ∈ combinations
        if sum(i) == cutoff
            return (sum(i), i)
        end
    end
end

function find_expenses(expenses, λ::Int=2)
    expense_combinations = combinations(expenses, λ)
    result = find_expense_meeting_cutoff_value(expense_combinations, 2020)
    
    return result, cumprod(result[2])
end

# data = "resources/01122020/test.txt"
data = "resources/01122020/input.txt"

data_input = parse.(Int, readlines(data))
@show find_expenses(data_input, 3)