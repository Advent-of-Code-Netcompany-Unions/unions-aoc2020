function get_known_rules(ids_and_rules)::Dict{Integer, Array{AbstractString, 1}}
  parsed_rules = Dict{Integer, Array{AbstractString, 1}}()
  already_mapped_rules = findall(x -> occursin("\"", x[2]), ids_and_rules)

  for known_rule ∈ already_mapped_rules
    id_and_rule = ids_and_rules[known_rule]
    parsed_rules[parse(Int, id_and_rule[1])] = [replace(id_and_rule[2], '"' => "")]
  end

  return parsed_rules
end

function get_rules(ids_and_rules::Dict{Integer, AbstractString}, known_rules::Dict{Integer, Array{AbstractString, 1}}, current_rule_id::Integer = 0)::Tuple{Array{AbstractString, 1}, Dict{Integer, Array{AbstractString, 1}}}
  if (haskey(known_rules, current_rule_id))
    return known_rules[current_rule_id], known_rules
  else
    rules_arr::Array{Array{Integer, 1}, 1} = [parse.(Int, element) for element in split.(split(ids_and_rules[current_rule_id], " | "), " ")]
    new_rules::Array{Array{AbstractString, 1}, 1} = Array{Array{AbstractString, 1}, 1}(undef, size(rules_arr, 1))
    for (rule_arr_idx, rule_arr) ∈ enumerate(rules_arr)
      local new_rule::Array{AbstractString, 1} = [""]
      for rule_id ∈ rule_arr
        nested_rule, known_rules = get_rules(ids_and_rules, known_rules, rule_id)
        new_rule = collect(AbstractString, Iterators.flatten([ element .* nested_rule for element in new_rule ]))
        if (rule_arr_idx <= size(new_rules, 1))
          new_rules[rule_arr_idx] = new_rule
        else
          push!(new_rules, new_rule)
        end
      end
    end
    flattened_rules::Array{AbstractString, 1} = collect(Iterators.flatten(new_rules))
    if (!haskey(known_rules, current_rule_id))
      known_rules[current_rule_id] = flattened_rules
    end

    return flattened_rules, known_rules
  end
end

function parse_input_rules(raw_rules::AbstractString)::Dict{Integer, Array{AbstractString, 1}}
  ids_and_rules = split.(split(raw_rules, r"\n"), r":\s")
  known_rules = get_known_rules(ids_and_rules)
  d = Dict{Integer, AbstractString}([(parse(Int, id_and_rule[1]), replace(id_and_rule[2], '"' => "")) for id_and_rule in ids_and_rules])
  
  return get_rules(d, known_rules, 0)[2]
end

function zoom_and_ENHANCE(input, puzzle_part)
  println("Parsing input")
  rules = parse_input_rules(input[1])

  valid_images = 0
  valid_images_pt2 = 0
  println("Validating images")
  for image ∈ split(input[2], r"\n")
    if (image in rules[0])
      valid_images += 1
    elseif (puzzle_part == 2)
      section_length = length(rules[42][1])
      n_sections = length(image) ÷ section_length
      starts_with_r42 = false
      has_matched = false
      for rule in rules[42]
        if (startswith(image, rule))
          starts_with_r42 = true
          break
        end
      end

      if (!starts_with_r42)
        continue
      end

      image_arr = collect(image)
      image_sections = [join(image_arr[1 + section_length * n:section_length + section_length*n]) for n in 0:n_sections-1]

      m_r42 = 0
      m_r31 = 0
      stopped_matching_r42 = false
      for (section_idx, section) in enumerate(image_sections)
        local in_r42 = false
        local in_r31 = false
        if (!stopped_matching_r42)
          in_r42 = section in rules[42]
        end

        if (section_idx >= n_sections ÷ 2 + 1)
          in_r31 = section in rules[31]
        end
        if (!in_r42 && !stopped_matching_r42)
          stopped_matching_r42 = true
        end

        m_r42 += in_r42
        m_r31 += in_r31
      end

      if (m_r31 > 0 && m_r42-1 >= m_r31 && m_r42 + m_r31 == n_sections )
        valid_images_pt2 += 1
      end
    end
  end

  return (valid_images, valid_images_pt2, valid_images + valid_images_pt2)
end

# data = "resources/19122020/testa.txt"
# data = "resources/19122020/testb.txt"
data = "resources/19122020/input.txt"

data_input = split(read(data, String), r"\n\n")
puzzle_part = 2

@show zoom_and_ENHANCE(data_input, puzzle_part)