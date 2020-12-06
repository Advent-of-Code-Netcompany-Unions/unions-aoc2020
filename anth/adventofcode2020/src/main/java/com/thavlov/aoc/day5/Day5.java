package com.thavlov.aoc.day5;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day5 {
    private static final String INPUT_FILE = "./day5/input.txt";
    private static List<BoardingPass> boardingPass;

    private static void init() throws URISyntaxException, IOException {
        URL url = Optional.ofNullable(Day5.class.getClassLoader().getResource(INPUT_FILE))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", INPUT_FILE)));

        Path path = Paths.get(url.toURI());

        try (Stream<String> linesFromFile = Files.lines(path)) {
            boardingPass = linesFromFile.map(BoardingPass::new).collect(Collectors.toList());
        }
    }

    public static String solvePart1() {
        try {
            init();
            return Integer.toString(boardingPass.stream()
                    .mapToInt(BoardingPass::getBoardingPassId)
                    .max()
                    .orElseThrow(() -> new UnknownError("Unknown max value.")));
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    public static String solvePart2() {
        try {
            init();
            final int[] boardingPassIds = boardingPass.stream().mapToInt(BoardingPass::getBoardingPassId).sorted().toArray();
            for (int i = 0; i < boardingPassIds.length - 1; i++) {
                if (boardingPassIds[i + 1] - boardingPassIds[i] == 2) {
                    return Integer.toString((boardingPassIds[i + 1] + boardingPassIds[i]) / 2);
                }
            }
            return "Unknown result....";
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    private Day5() { }
}
