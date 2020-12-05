package com.wismann.aoc.day5;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.function.Function;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String filename = "resources/day5.txt";

        System.out.println(solveFirstProblem(filename));
        System.out.println(solveSecondProblem(filename));
    }

    private static int solveSecondProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        final int rows = 128;
        final int columns = 8;

        Map<String, Integer> seatIdMap = lines.stream()
                .collect(Collectors.toMap(Function.identity(),
                        s -> calculateSeatId(s, rows, columns)));


        List<Integer> ids = seatIdMap.values().stream().sorted(Comparator.naturalOrder()).collect(Collectors.toList());


        int result = -1;

        for (int i = 0; i < ids.size(); i++) {
            if (ids.get(i+1) != ids.get(i)+1) {
                result = ids.get(i+1)-1;
                break;
            }
        }

        return result;

    }

    private static int solveFirstProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        final int rows = 128;
        final int columns = 8;

        Map<String, Integer> seatIdMap = lines.stream()
                .collect(Collectors.toMap(Function.identity(),
                        s -> calculateSeatId(s, rows, columns)));


        return seatIdMap.values().stream().max(Comparator.naturalOrder()).orElse(0);
    }

    private static int calculateSeatId(String boardingPass, int rows, int columns) {
        String rowString = boardingPass.substring(0, 7);
        String columnString = boardingPass.substring(7);

        int rowNumber = searchRow(rowString, 0 , rows-1);
        int columnNumber = searchColumn(columnString, 0, columns-1);

        return rowNumber * 8 + columnNumber;
    }

    private static int searchRow(String s, int min, int max) {
        int seatsLeft = max-min + 1;

        if (seatsLeft == 1) {
            return min;
        }

        if (s.charAt(0) == 'F') {
            return searchRow(s.substring(1), min, min + (seatsLeft/2) - 1);
        }

        if (s.charAt(0) == 'B') {
            return searchRow(s.substring(1), min + (seatsLeft/2), max);
        }

        return -1;
    }

    private static int searchColumn(String s, int min, int max) {
        int seatsLeft = max-min + 1;

        if (seatsLeft == 1) {
            return min;
        }

        if (s.charAt(0) == 'L') {
            return searchColumn(s.substring(1), min, min + (seatsLeft/2) - 1);
        }

        if (s.charAt(0) == 'R') {
            return searchColumn(s.substring(1), min + (seatsLeft/2), max);
        }

        return -1;
    }

}
