package com.wismann.aoc.day2;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collector;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Main {

    public static void main(String[] args) throws IOException {

        String filename = "resources/day2.txt";

        System.out.println(solveFirstProblem(filename));
        System.out.println(solveSecondProblem(filename));

    }

    private static int solveFirstProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        int validCount = 0;

        for (String s : lines) {
            String[] split = s.split(" ");
            String[] minMaxSplit = split[0].split("-");

            int min = Integer.valueOf(minMaxSplit[0]);
            int max = Integer.valueOf(minMaxSplit[1]);
            char letter = split[1].charAt(0);
            String password = split[2];

            char[] charsInPw = password.toCharArray();

            int count = 0;
            for (char c : charsInPw) {
                if (c == letter) {
                    count++;
                }
            }

            if (count >= min && count <= max) {
                validCount++;
            }
        }

        return validCount;
    }

    private static int solveSecondProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        int validCount = 0;

        for (String s : lines) {
            String[] split = s.split(" ");
            String[] minMaxSplit = split[0].split("-");

            int firstIndex = Integer.valueOf(minMaxSplit[0]);
            int secondIndex = Integer.valueOf(minMaxSplit[1]);
            char letter = split[1].charAt(0);
            String password = split[2];

            char[] charsInPw = password.toCharArray();

            if ((charsInPw[firstIndex-1] == letter && charsInPw[secondIndex-1] != letter) ||
                    (charsInPw[firstIndex-1] != letter && charsInPw[secondIndex-1] == letter)) {
                validCount++;
            }

        }

        return validCount;
    }
}
