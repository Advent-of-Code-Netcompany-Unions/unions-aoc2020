package com.wismann.aoc.day4;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String filename = "resources/day4.txt";

        System.out.println(solveFirstProblem(filename));
        System.out.println(solveSecondProblem(filename));
    }

    private static int solveFirstProblem(String inputFile) throws IOException {
        List<Map<String, String>> passPortList = buildPassPortList(inputFile);
        return countValidSimple(passPortList);
    }

    private static long solveSecondProblem(String inputFile) throws IOException {
        List<Map<String, String>> passPortList = buildPassPortList(inputFile);
        return passPortList.stream().filter(Main::isPassportValid).count();
    }

    private static boolean isPassportValid(Map<String, String> passport) {
        boolean birthYearValid = passport.containsKey("byr") && isBirthYearValid(passport.get("byr"));
        boolean issueYearValid = passport.containsKey("iyr") && isIssueYearValid(passport.get("iyr"));
        boolean expirationYearValid = passport.containsKey("eyr") && isExpirationYearValid(passport.get("eyr"));
        boolean heightValid = passport.containsKey("hgt") && isHeightValid(passport.get("hgt"));
        boolean hairColorValid = passport.containsKey("hcl") && isHairColorValid(passport.get("hcl"));
        boolean eyeColorValid = passport.containsKey("ecl") && isEyeColorValid(passport.get("ecl"));
        boolean passportIdValid = passport.containsKey("pid") && isPassportIdValid(passport.get("pid"));

        return birthYearValid && issueYearValid && expirationYearValid && heightValid &&
                hairColorValid && eyeColorValid && passportIdValid;
    }

    private static boolean isBirthYearValid(String s) {
        int i = Integer.parseInt(s);
        return i >= 1920 && i <= 2002;
    }

    private static boolean isIssueYearValid(String s) {
        int i = Integer.parseInt(s);
        return i >= 2010 && i <= 2020;
    }

    private static boolean isExpirationYearValid(String s) {
        int i = Integer.parseInt(s);
        return i >= 2020 && i <= 2030;
    }

    private static boolean isHeightValid(String s) {
        int i = Integer.parseInt(s.replaceAll("cm|in", ""));
        String unit = s.replaceAll("\\d", "");

        if (unit.equals("cm")) {
            return i >= 150 && i <= 193;
        }
        if (unit.equals("in")) {
            return i >= 59 && i <= 76;
        }

        return false;
    }

    private static boolean isHairColorValid(String s) {
        return s.matches("#([a-f]|[0-9]){6}");
    }

    private static boolean isEyeColorValid(String s) {
        List<String> validColor = Arrays.asList("amb", "blu", "brn", "gry", "grn", "hzl", "oth");
        return validColor.contains(s);
    }

    private static boolean isPassportIdValid(String s) {
        return  s.matches("\\d{9}");
    }


    private static List<Map<String, String>> buildPassPortList(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        List<Map<String, String>> passPortList = new ArrayList<>();
        Map<String, String> passPort = new HashMap<>();

        for (String line : lines) {
            if (line.isEmpty()) {
                passPortList.add(passPort);
                passPort = new HashMap<>();
                continue;
            }

            String[] props = line.split(" ");
            for (String prop : props) {
                String[] keyValue = prop.split(":");
                passPort.put(keyValue[0], keyValue[1]);
            }
        }

        return passPortList;
    }

    private static int countValidSimple(List<Map<String, String>> passportList) {
        List<String> requiredProps = Arrays.asList("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid");

        int validPassports = 0;
        for (Map<String, String> m : passportList) {
            boolean hasReqProps = requiredProps.stream().allMatch(p -> m.containsKey(p));
            if (hasReqProps) {
                validPassports++;
            }
        }
        return validPassports;
    }
}
