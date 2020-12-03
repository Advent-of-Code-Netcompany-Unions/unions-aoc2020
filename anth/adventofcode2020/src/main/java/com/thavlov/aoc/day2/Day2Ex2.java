package com.thavlov.aoc.day2;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Day2Ex2 {
    private static List<String> lines;

    private static void init() throws Exception {
        URL url = Day2Ex1.class.getClassLoader().getResource("./day2/input.txt");
        Path path = Paths.get(url.toURI());

        lines = Files.lines(path).collect(Collectors.toList());
    }

    public static String solve() throws Exception {
        init();

        return Long.toString(lines.stream()
                .map(PasswordEntry::fromString)
                .filter(PasswordEntry::isValid)
                .count());
    }
}
