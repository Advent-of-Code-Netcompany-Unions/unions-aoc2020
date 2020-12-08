function validate_byr(byr::SubString{String})::Bool
    birth_year = parse(Int, byr)
    return birth_year >= 1920 && birth_year <= 2002
end

function validate_iyr(iyr::SubString{String})::Bool
    issue_year = parse(Int, iyr)
    return issue_year >= 2010 && issue_year <= 2020
end

function validate_eyr(eyr::SubString{String})::Bool
    expiration_year = parse(Int, eyr)
    return expiration_year >= 2020 && expiration_year <= 2030
end

function validate_hgt(hgt::SubString{String})::Bool
    m = match(r"(\d+)(cm|in)", hgt)
    if (m === nothing)
        return false
    end

    height_str, unit = m.captures
    height = parse(Int, height_str)
    if (unit == "in")
        return height >= 59 && height <= 76
    else
        return height >= 150 && height <= 193
    end
end

function validate_hcl(hcl::SubString{String})::Bool
    return !(match(r"#[a-f0-9]{6}", hcl) === nothing)
end

function validate_ecl(ecl::SubString{String})::Bool
    return !(match(r"(amb|blu|brn|gry|grn|hzl|oth)", ecl) === nothing)
end

function validate_pid(pid::SubString{String})::Bool
    return !(match(r"^\d{9}$", pid) === nothing)
end

function has_valid_required_fields(passport::Dict)::Bool
   return validate_byr(passport["byr"]) && 
        validate_ecl(passport["ecl"]) && 
        validate_eyr(passport["eyr"]) && 
        validate_hcl(passport["hcl"]) && 
        validate_hgt(passport["hgt"]) && 
        validate_iyr(passport["iyr"]) && 
        validate_pid(passport["pid"])
end

function has_required_fields(passport::Dict)::Bool
    for required_field ∈ required_fields
        if (!haskey(passport, required_field))
            return false
        end
    end

    return true
end

function is_valid_passport_info(passport::Dict)::Bool
    required_fields_present = has_required_fields(passport)

    if (!required_fields_present)
        return false
    end

    return has_valid_required_fields(passport)
end

function is_valid_passport(passport_info::SubString{String})::Bool
    passport = Dict()
    passport_keys = split(passport_info, r"\s")
    for passport_key ∈ passport_keys
        m = match(passport_field_regex, passport_key)
        passport[m[:key]] = m[:value]
    end

    return is_valid_passport_info(passport)
end

function find_valid_passports(passport_informations)
    valid_passports = 0
    for passport_info ∈ passport_informations
        valid_passports += is_valid_passport(passport_info) ? 1 : 0
    end

    return valid_passports
end

# data = "resources/04122020/test.txt"
data = "resources/04122020/input.txt"

required_fields = ["byr", "ecl", "eyr", "iyr", "hgt", "hcl", "pid"]

passport_field_regex = r"^(?<key>\w{3}):(?<value>.*)$"

data_input = split(read(data, String), r"\n\n")
@show find_valid_passports(data_input)