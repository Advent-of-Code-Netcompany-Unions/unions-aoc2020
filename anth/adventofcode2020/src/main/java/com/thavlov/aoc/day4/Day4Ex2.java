package com.thavlov.aoc.day4;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day4Ex2 {
    private static final String INPUT_FILE = "./day4/input.txt";
    private static final List<PassportEntry> passports = new ArrayList<>();

    private static void init() throws URISyntaxException, IOException {
        URL url = Optional.ofNullable(Day4Ex2.class.getClassLoader().getResource(INPUT_FILE))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", INPUT_FILE)));

        Path path = Paths.get(url.toURI());

        List<String> rawLines;
        try (Stream<String> linesFromFile = Files.lines(path)) {
            rawLines = linesFromFile.collect(Collectors.toList());
        }

        StringBuilder line = new StringBuilder();
        for (String s : rawLines) {
            if ("".equals(s)) {
                passports.add(PassportEntry.parseFromString(line.toString()));
                line = new StringBuilder();
                continue;
            }
            line.append(" ").append(s);
        }
        passports.add(PassportEntry.parseFromString(line.toString()));
    }

    public static String solve() {
        try {
            init();
            return Integer.toString((int) passports.stream().filter(PassportEntry::isValidExtended).count());
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }
}
