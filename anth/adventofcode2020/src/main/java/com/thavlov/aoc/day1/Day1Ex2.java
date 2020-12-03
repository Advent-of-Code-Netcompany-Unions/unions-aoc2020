package com.thavlov.aoc.day1;

import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Day1Ex2 {
    private static int[] expences;

    private static void init() throws Exception {
        URL url = Day1Ex2.class.getClassLoader().getResource("./day1/input.txt");
        Path path = Paths.get(url.toURI());

        expences = Files.lines(path)
                .mapToInt(Integer::new)
                .toArray();
    }

    public static String solve() throws Exception {
        init();

        for (int i = 0; i < expences.length; i++) {
            for (int j = 0; j < expences.length; j++) {
                if (i == j) {
                    continue;
                }
                for (int k = 0; k < expences.length; k++) {
                    if (j != k && (expences[i] + expences[j] + expences[k]) == 2020) {
                        return Integer.toString(expences[i] * expences[j] * expences[k]);
                    }
                }
            }
        }

        return "Unknown";
    }
}
