package com.thavlov.aoc.day10;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.thavlov.aoc.day6.Day6;

public class Day10 {
    private static final String INPUT_FILE = "./day10/input.txt";
    private static final int JOLT_DIFF = 3;

    private static List<Integer> adapterJoltRating;

    private static void init() throws URISyntaxException, IOException {
        URL url = Optional.ofNullable(Day6.class.getClassLoader().getResource(INPUT_FILE))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", INPUT_FILE)));

        Path path = Paths.get(url.toURI());

        try (Stream<String> linesFromFile = Files.lines(path)) {
            adapterJoltRating = linesFromFile.map(Integer::parseInt).collect(Collectors.toList());
        }
        int maxJolt = adapterJoltRating.stream().mapToInt(Integer::intValue).max().getAsInt();
        adapterJoltRating.add(0);
        adapterJoltRating.add(maxJolt + JOLT_DIFF);
        Collections.sort(adapterJoltRating);
    }

    public static String solvePart1() {
        try {
            init();

            int[] joltDiffs = new int[3];

            for (int i = 0; i < adapterJoltRating.size() - 1; i++) {
                int diff = adapterJoltRating.get(i + 1) - adapterJoltRating.get(i);
                joltDiffs[diff - 1]++;
            }
            return Integer.toString((joltDiffs[0]) * (joltDiffs[2]));
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    public static String solvePart2() {
        try {
            init();
            initAdapterToAdaptersMap();

            final int lastIndex = adapterJoltRating.size() - 1;
            return Long.toString(numberOfWaysToArriveAt(lastIndex));
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    private static final Map<Integer, List<Integer>> adapterToAdaptersMap = new HashMap<>();

    private static void initAdapterToAdaptersMap() {
        for (int i = 0; i < adapterJoltRating.size(); i++) {
            adapterToAdaptersMap.put(i, getIndicesAccessibleFrom(i));
        }
    }

    private static List<Integer> getIndicesAccessibleFrom(int index) {
        int valueAtIndex = adapterJoltRating.get(index);
        int nextValue;
        List<Integer> result = new ArrayList<>();
        int counter = 0;
        while (index - counter - 1 >= 0) {
            nextValue = adapterJoltRating.get(index - counter - 1);
            if (valueAtIndex - nextValue <= 3) {
                result.add(index - counter - 1);
                counter++;
            } else {
                return result;
            }
        }
        return result;
    }

    private static final Map<Integer, Long> ways = new HashMap<>();

    private static long numberOfWaysToArriveAt(int index) {
        final List<Integer> integers = adapterToAdaptersMap.get(index);

        if (integers.isEmpty()) {
            return 1;
        }

        long sum = 0;
        for (Integer integer : integers) {
            sum += ways.computeIfAbsent(integer, Day10::numberOfWaysToArriveAt);
        }

        return sum;
    }

    private Day10() { }
}
