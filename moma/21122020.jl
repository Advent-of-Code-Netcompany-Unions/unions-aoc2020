function parse_food_declarations(input::String)::Tuple{Dict{String, Array{String, 1}}, Array{String, 1}, Array{String, 1}}
    # first get all ingredients and allergens
    all_ingredients = Array{String, 1}()
    all_allergens = Array{String, 1}()
    allergens_to_ingredients = Dict{String, Array{String, 1}}()
    foods::Array{String, 1} = string.(split(input, "\n"))
    for food ∈ foods
        ingredients_allergens = split(food, " (contains ")
        ingredients = string.(split(ingredients_allergens[1], " "))
        allergens = string.(split(ingredients_allergens[2][1:end-1], ", "))

        all_ingredients = vcat(all_ingredients, ingredients)
        all_allergens = vcat(all_allergens, allergens)
        for allergen ∈ allergens
            if (!haskey(allergens_to_ingredients, allergen))
                allergens_to_ingredients[allergen] = ingredients
            else
                allergens_to_ingredients[allergen] = intersect(allergens_to_ingredients[allergen], ingredients)
            end
        end
    end

    distinct_allergens = findall(entry -> size(values(entry), 1) == 1, allergens_to_ingredients)
    while true
        information_updated = false
        for allergen1 ∈ distinct_allergens
            for allergen2 ∈ setdiff(keys(allergens_to_ingredients), distinct_allergens)
                if (allergens_to_ingredients[allergen1][1] in allergens_to_ingredients[allergen2])
                    information_updated = true
                    filter!(λ -> λ ≠ allergens_to_ingredients[allergen1][1], allergens_to_ingredients[allergen2])
                end
            end
        end

        if (!information_updated)
            break
        end

        distinct_allergens = findall(entry -> size(values(entry), 1) == 1, allergens_to_ingredients)
    end

    return allergens_to_ingredients, all_ingredients, foods
end

function find_ingredients_without_side_effects(all_ingredients::Array{String, 1}, all_foods::Array{String, 1}, allergens_to_ingredients::Dict{String, Array{String, 1}})::Int
    non_allergetic_foods = deepcopy(all_ingredients)
    for (allergen, ingredients) ∈ allergens_to_ingredients
        filter!(λ -> λ ≠ ingredients[1], non_allergetic_foods)
    end

    times_mentioned = 0
    for non_allergetic_food ∈ non_allergetic_foods
        for food ∈ all_foods
            if (occursin(non_allergetic_food, food))
                times_mentioned += 1
                break
            end
        end
    end

    return times_mentioned
end

function construct_dangerous_ingredients_list(allergens_to_ingredients::Dict{String, Array{String, 1}})::String
    dangerous_ingredients_list = ""
    for sorted_allergen ∈ sort(collect(keys(allergens_to_ingredients)))
        dangerous_ingredients_list *= ",$(allergens_to_ingredients[sorted_allergen][1])"
    end

    return dangerous_ingredients_list[2:end]
end

function excuse_me_does_this_contain(input::String, puzzle_part::Int)
    allergens_to_ingredients, all_ingredients, all_foods = parse_food_declarations(input)
    if puzzle_part == 1
        return find_ingredients_without_side_effects(all_ingredients, all_foods, allergens_to_ingredients)
    else
        return construct_dangerous_ingredients_list(allergens_to_ingredients)
    end
end

# data = "resources/21122020/test.txt"
data = "resources/21122020/input.txt"

str = read(open(data), String)
puzzle_part = 1

@show excuse_me_does_this_contain(str, puzzle_part)