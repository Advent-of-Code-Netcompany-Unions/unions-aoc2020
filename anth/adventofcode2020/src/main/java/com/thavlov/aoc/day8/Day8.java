package com.thavlov.aoc.day8;

import java.util.List;

public class Day8 {
    private static final String INPUT_FILE = "./day8/input.txt";

    public static String solvePart1() {
        try {
            final GameConsole gameConsole = GameConsole.loadFromFile(INPUT_FILE);
            int output = gameConsole.runApplication();
            return Integer.toString(output);
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    public static String solvePart2() {
        try {
            final GameConsole gameConsole = GameConsole.loadFromFile(INPUT_FILE);
            final List<Integer> indicesWithJmpAndNop = gameConsole.getIndicesWithJmpAndNop();

            for (Integer integer : indicesWithJmpAndNop) {
                int output = gameConsole.runApplicationWithFlipIndex(integer);
                if (output != Integer.MIN_VALUE) {
                    return Integer.toString(output);
                }
            }
            return Integer.toString(1);
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    private Day8() {
    }
}
