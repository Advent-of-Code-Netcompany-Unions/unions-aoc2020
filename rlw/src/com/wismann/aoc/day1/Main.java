package com.wismann.aoc.day1;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {

        String filename = "resources/day1.txt";

        System.out.println(solveFirstProblem(filename));
        System.out.println(solveSecondProblem(filename));

    }

    private static int solveSecondProblem(String inputFile) throws IOException {
        List<Integer> lines = Files.lines(Paths.get(inputFile))
                .map(Integer::valueOf).collect(Collectors.toList());

        int result = 0;

        for (Integer i : lines) {
            for (Integer j : lines) {
                for(Integer k : lines) {
                    if (i + j + k == 2020) {
                        result = i*j*k;
                    }
                }
            }
        }

        return result;
    }

    private static int solveFirstProblem(String inputFile) throws IOException {
        List<Integer> lines = Files.lines(Paths.get(inputFile))
                .map(Integer::valueOf).collect(Collectors.toList());

        int result = 0;

        for (Integer i : lines) {
            for (Integer j : lines) {
                if (i + j == 2020) {
                    result = i*j;
                }
            }
        }

        return result;
    }
}
