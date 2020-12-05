package com.thavlov.aoc.day4;

import java.util.HashMap;
import java.util.Map;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PassportEntry {
    private final Map<String, String> data = new HashMap<>();

    private PassportEntry() {
    }

    public static PassportEntry parseFromString(final String s) {
        PassportEntry result = new PassportEntry();
        StringTokenizer st = new StringTokenizer(s);
        String[] keyValuePair;
        while (st.hasMoreTokens()) {
            keyValuePair = st.nextToken().split(":");
            result.addKeyValuePair(keyValuePair[0], keyValuePair[1]);
        }
        return result;
    }

    private void addKeyValuePair(String key, String value) {
        data.put(key, value);
    }

    public boolean isValidBasic() {
        return data.containsKey("byr") &&
                data.containsKey("iyr") &&
                data.containsKey("eyr") &&
                data.containsKey("hgt") &&
                data.containsKey("hcl") &&
                data.containsKey("ecl") &&
                data.containsKey("pid");
    }

    public boolean isValidExtended() {
        return validateByr() &&
                validateIyr() &&
                validateEyr() &&
                validateHgt() &&
                validateHcl() &&
                validateEcl() &&
                validatePid();
    }

    private boolean validateByr() {
        String value = data.getOrDefault("byr", "");
        if ("".equals(value)) {
            return false;
        }
        return value.length() == 4 && Integer.parseInt(value) >= 1920 && Integer.parseInt(value) <= 2002;
    }

    private boolean validateIyr() {
        String value = data.getOrDefault("iyr", "");
        if ("".equals(value)) {
            return false;
        }
        return value.length() == 4 && Integer.parseInt(value) >= 2010 && Integer.parseInt(value) <= 2020;
    }

    private boolean validateEyr() {
        String value = data.getOrDefault("eyr", "");
        if ("".equals(value)) {
            return false;
        }
        return value.length() == 4 && Integer.parseInt(value) >= 2020 && Integer.parseInt(value) <= 2030;
    }

    private boolean validateHgt() {
        String value = data.getOrDefault("hgt", "");
        if ("".equals(value)) {
            return false;
        }

        String regex = "([0-9]+)(cm|in)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(value);

        if (!matcher.find()) {
            return false;
        }

        switch (matcher.group(2)) {
            case "cm":
                int heightInCm = Integer.parseInt(matcher.group(1));
                return heightInCm >= 150 && heightInCm <= 193;
            case "in":
                int heightInIn = Integer.parseInt(matcher.group(1));
                return heightInIn >= 59 && heightInIn <= 76;
            default:
                throw new IllegalArgumentException(String.format("Unknown height type: %s", matcher.group(2)));
        }
    }

    private boolean validateHcl() {
        String value = data.getOrDefault("hcl", "");

        if ("".equals(value)) {
            return false;
        }
        String regex = "#([0-9a-f]+)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(value);

        return matcher.find() && matcher.group(1).length() == 6;
    }

    private boolean validateEcl() {
        String value = data.getOrDefault("ecl", "");
        if ("".equals(value)) {
            return false;
        }

        return "amb".equals(value) || "blu".equals(value) || "brn".equals(value) || "gry".equals(value) || "grn".equals(value) || "hzl".equals(value) || "oth".equals(value);
    }

    private boolean validatePid() {
        String value = data.getOrDefault("pid", "");
        if ("".equals(value)) {
            return false;
        }

        String regex = "([0-9]+)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(value);

        return matcher.find() && matcher.group(1).length() == 9;
    }
}
