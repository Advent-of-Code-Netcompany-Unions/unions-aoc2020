using LightGraphs, MetaGraphs

function find_bag_parents_and_children(bag_rules::Array{String, 1})::Array{Tuple{SubString{String},Array{Tuple{SubString{String},Int64},1}},1}
    bag_color_quantity_regex = r"(?<qty>\d)\s(?<bag_color>[\w\s]+)"
    bags_in_bags_regex = r"(\sbags?(,\s|\.)|no other bags.)"

    parents_and_children = Array{Tuple{SubString{String},Array{Tuple{SubString{String},Int64},1}},1}(undef, size(bag_rules, 1))    
    for (i, rule) ∈ enumerate(bag_rules)
        rule_split = split(rule, r"\sbags\scontain\s")

        parent = rule_split[1]

        bags_in_bags = split(rule_split[2], bags_in_bags_regex, keepempty=false)
        children = Array{Tuple{SubString{String},Int64},1}(undef, size(bags_in_bags, 1))
        for (j, bag_in_bags) ∈ enumerate(bags_in_bags)
            m = match(bag_color_quantity_regex, bag_in_bags)
            children[j] = (m[:bag_color], parse(Int64, m[:qty]))
        end

        parents_and_children[i] = (parent, children)
    end

    return parents_and_children
end

function traverse_connections(directed_graph, from_vertex, weight_parent = 1)
    count_bags_in_bag = weight_parent
    out_neighbours = outneighbors(directed_graph, from_vertex)

    from_vertex_name = directed_graph[from_vertex, :name]

    for out_neighbour ∈ out_neighbours
        out_neighbour_name = directed_graph[out_neighbour, :name]
        count_bags_in_bag += weight_parent * traverse_connections(directed_graph, out_neighbour, get_prop(directed_graph, from_vertex, out_neighbour, :weight))
    end

    return count_bags_in_bag    
end

function create_directed_graph(parents_and_children)
    g = Graph(size(parents_and_children, 1))
    mg = MetaDiGraph(g)

    for (i, v) in enumerate(vertices(mg))
        set_prop!(mg, v, :name, parents_and_children[i][1])
    end

    set_indexing_prop!(mg, :name)

    for (parent, children) ∈ parents_and_children
        if isempty(children)
            continue
        end

        for (child, weight) ∈ children
            add_edge!(mg, mg[parent, :name], mg[child, :name], :weight, weight)
        end
    end
    
    return mg
end

function process_luggage(rules::Array{String}, puzzle_part::Int)
    shiny_gold_bag = "shiny gold"

    parents_and_children = find_bag_parents_and_children(rules)

    mg = create_directed_graph(parents_and_children)

    if (puzzle_part == 1)
        # subtract one as it counts itself as a parent
        all_paths_lead_to_shiny_gold = cumsum(bfs_parents(mg, mg[shiny_gold_bag, :name], dir=:in) .!= 0)[end] - 1

        return all_paths_lead_to_shiny_gold
    else
        shiny_gold_vertex = mg[shiny_gold_bag, :name]
        # subtract 1 as the bag itself is included in the recursive summation
        bags_in_my_shiny_gold_bag = traverse_connections(mg, shiny_gold_vertex) - 1

        return bags_in_my_shiny_gold_bag
    end
end

# data = "resources/07122020/test.txt"
data = "resources/07122020/input.txt"

rules = readlines(data)

@show process_luggage(rules, 2)