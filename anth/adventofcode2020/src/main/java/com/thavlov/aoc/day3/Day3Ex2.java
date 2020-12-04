package com.thavlov.aoc.day3;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Day3Ex2 {
    private static boolean[][] map;

    private static void init() throws Exception {
        URL url = Day3Ex2.class.getClassLoader().getResource("./day3/input.txt");
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

        int treesCount1 = getTreeCountFromDecent(1, 1);
        int treesCount2 = getTreeCountFromDecent(1, 3);
        int treesCount3 = getTreeCountFromDecent(1, 5);
        int treesCount4 = getTreeCountFromDecent(1, 7);
        int treesCount5 = getTreeCountFromDecent(2, 1);

        return Integer.toString(treesCount1 * treesCount2 * treesCount3 * treesCount4 * treesCount5);
    }

    private static int getTreeCountFromDecent(int slopeX, int slopeY) {
        int trees = 0;
        int yCoord = 0;
        int yLength = map[0].length;

        for (int xCoord = 0; xCoord < map.length; xCoord += slopeX) {
            if (map[xCoord][yCoord]) {
                trees++;
            }
            yCoord += slopeY;
            yCoord %= yLength;
        }
        return trees;
    }
}
