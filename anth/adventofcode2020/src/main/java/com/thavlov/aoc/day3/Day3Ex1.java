package com.thavlov.aoc.day3;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Day3Ex1 {
    private static boolean[][] map;

    private static void init() throws Exception {
        URL url = Day3Ex1.class.getClassLoader().getResource("./day3/input.txt");
        Path path = Paths.get(url.toURI());

        final List<String> stringMap = Files.lines(path).collect(Collectors.toList());

        map = new boolean[stringMap.size()][stringMap.get(0).length()];

        for (int i = 0; i < stringMap.size(); i++) {
            map[i] = parseLine(stringMap.get(i));
        }
    }

    private static boolean[] parseLine(final String line) {
        final boolean[] result = new boolean[line.length()];
        for (int i = 0; i < line.length(); i++) {
            result[i] = line.charAt(i) == '#';
        }
        return result;
    }

    public static String solve() throws Exception {
        init();
        int counter = 0;
        int yCoord = 0;
        int yLength = map[0].length;

        for (int xCoord = 0; xCoord < map.length; xCoord++) {
            if (map[xCoord][yCoord]) {
                counter++;
            }
            yCoord += 3;
            yCoord %= yLength;
        }

        return Integer.toString(counter);
    }
}
