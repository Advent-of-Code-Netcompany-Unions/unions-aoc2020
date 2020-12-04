package com.thavlov.aoc.day2;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.StringTokenizer;
import java.util.stream.Collectors;

public class Day2Ex1 {
    private static List<String> lines;

    private static void init() throws Exception {
        URL url = Day2Ex1.class.getClassLoader().getResource("./day2/input.txt");
        Path path = Paths.get(url.toURI());

        lines = Files.lines(path).collect(Collectors.toList());
    }

    public static String solve() throws Exception {
        init();

        return Long.toString(lines.stream().filter(Day2Ex1::processLine).count());
    }

    private static boolean processLine(String line) {
        line = line.replace("-", " ").replace(":", "");

        StringTokenizer stringTokenizer = new StringTokenizer(line);
        int min = Integer.parseInt(stringTokenizer.nextToken());
        int max = Integer.parseInt(stringTokenizer.nextToken());
        char letter = stringTokenizer.nextToken().charAt(0);
        String password = stringTokenizer.nextToken();

        int occurrence = findOccurrences(password, letter);

        return occurrence >= min && occurrence <= max;
    }

    private static int findOccurrences(String password, char letter) {
        return (int) password.chars().filter(c -> c == letter).count();
    }
}
