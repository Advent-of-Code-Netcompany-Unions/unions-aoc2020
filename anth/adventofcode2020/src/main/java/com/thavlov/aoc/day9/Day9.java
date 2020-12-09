package com.thavlov.aoc.day9;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Optional;
import java.util.stream.Stream;

import com.thavlov.aoc.day6.Day6;

public class Day9 {
    private static final String INPUT_FILE = "./day9/input.txt";

    private static long[] numbers;

    private static void init() throws URISyntaxException, IOException {
        URL url = Optional.ofNullable(Day6.class.getClassLoader().getResource(INPUT_FILE))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", INPUT_FILE)));

        Path path = Paths.get(url.toURI());

        try (Stream<String> linesFromFile = Files.lines(path)) {
            numbers = linesFromFile.mapToLong(Long::parseLong).toArray();
        }
    }

    public static String solvePart1() {
        try {
            init();

            int preAmble = 25;
            for (int i = 0; i < numbers.length; i++) {
                if (!isSumInRange(i, preAmble, numbers[i + preAmble])) {
                    return Long.toString(numbers[i + preAmble]);
                }
            }

            return Integer.toString(1);
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    public static String solvePart2() {
        try {
            init();
            long sumToFind = 1398413738;

            int preAmble = 2;
            while (preAmble < numbers.length) {
                for (int i = 0; i < numbers.length - preAmble; i++) {
                    if (getSumOfRange(i, preAmble) == sumToFind) {
                        return Long.toString(getMinMaxSumInRange(i, preAmble));
                    }
                }
                preAmble++;
            }

            return "No solution found!";
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    private static boolean isSumInRange(int offset, int range, long sum) {
        for (int i = offset; i < Math.min(offset + range, numbers.length); i++) {
            for (int j = offset; j < Math.min(offset + range, numbers.length); j++) {
                if (i != j && (numbers[i] + numbers[j]) == sum) {
                    return true;
                }
            }
        }
        return false;
    }

    private static long getMinMaxSumInRange(int offset, int range) {
        long min = Long.MAX_VALUE;
        long max = Long.MIN_VALUE;

        for (int i = offset; i < offset + range; i++) {
            min = Math.min(min, numbers[i]);
            max = Math.max(max, numbers[i]);
        }
        return min + max;
    }

    private static long getSumOfRange(int offset, int range) {
        long sum = 0;
        for (int i = offset; i < offset + range; i++) {
            sum += numbers[i];
        }
        return sum;
    }

    private Day9() { }
}
