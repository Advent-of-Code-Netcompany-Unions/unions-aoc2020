package com.wismann.aoc.day6;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String filename = "resources/day6.txt";

        System.out.println(solveFirstProblem(filename));
        System.out.println(solveSecondProblem(filename));
    }


    private static int solveFirstProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        List<Set<Character>> charactersInGroups = new ArrayList<>();
        Set<Character> chars = new HashSet<>();

        for (String line : lines) {
            if (line.isEmpty()) {
                charactersInGroups.add(chars);
                chars = new HashSet<>();
                continue;
            }

            for (char c : line.toCharArray()) {
                chars.add(c);
            }
        }

        return charactersInGroups.stream().mapToInt(set -> set.size()).sum();

    }


    private static int solveSecondProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());


        Set<Character> charsInGroup = new HashSet<>();
        List<Set<Character>> groupAnswers = new ArrayList<>();

        int count = 0;

        for (String line : lines) {
            charsInGroup = new HashSet<>();

            if (line.isEmpty()) {
                if (groupAnswers.size() > 0) {
                    HashSet<Character> charSet = new HashSet<>(groupAnswers.get(0));

                    for(Set<Character> groupAnswer : groupAnswers) {
                        charSet.retainAll(groupAnswer);
                    }

                    count += charSet.size();

                }

                groupAnswers = new ArrayList<>();
                continue;
            }

            for (char c : line.toCharArray()) {
                charsInGroup.add(c);
            }
            groupAnswers.add(charsInGroup);

        }

        return count;

    }

}
