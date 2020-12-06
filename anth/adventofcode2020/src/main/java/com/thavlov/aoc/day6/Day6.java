package com.thavlov.aoc.day6;

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

public class Day6 {
    private static final String INPUT_FILE = "./day6/input.txt";
    private static List<String> customsDeclarationForms;

    private static void init() throws URISyntaxException, IOException {
        URL url = Optional.ofNullable(Day6.class.getClassLoader().getResource(INPUT_FILE))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", INPUT_FILE)));

        Path path = Paths.get(url.toURI());

        try (Stream<String> linesFromFile = Files.lines(path)) {
            customsDeclarationForms = linesFromFile.collect(Collectors.toList());
        }
    }

    public static String solvePart1() {
        try {
            init();
            return Integer.toString(partitionInGroups().stream()
                    .mapToInt(Day6::getGroupCount)
                    .sum());
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    public static String solvePart2() {
        try {
            init();
            return Integer.toString(partitionInGroups().stream()
                    .mapToInt(Day6::getGroupCountAllYes)
                    .sum());
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    private static List<List<String>> partitionInGroups() {
        List<List<String>> result = new ArrayList<>();
        List<String> groupForms = new ArrayList<>();
        for (String customsDeclarationForm : customsDeclarationForms) {
            if ("".equals(customsDeclarationForm)) {
                result.add(groupForms);
                groupForms = new ArrayList<>();
                continue;
            }
            groupForms.add(customsDeclarationForm);
        }
        result.add(groupForms);
        return result;
    }

    public static int getGroupCount(List<String> groupDeclarationForms) {
        final String uniqueCharacters = findUniqueCharactersInList(groupDeclarationForms);
        return uniqueCharacters.length();
    }

    private static String findUniqueCharactersInList(List<String> groupDeclarationForms) {
        final StringBuilder combinedQuestions = new StringBuilder();

        for (String groupDeclarationForm : groupDeclarationForms) {
            for (char declarationFormChar : groupDeclarationForm.toCharArray()) {
                if (combinedQuestions.toString().indexOf(declarationFormChar) >= 0) {
                    continue;
                }
                combinedQuestions.append(declarationFormChar);
            }
        }
        return combinedQuestions.toString();
    }

    public static int getGroupCountAllYes(List<String> groupDeclarationForms) {
        return (int) findUniqueCharactersInList(groupDeclarationForms).chars()
                .filter(c -> doesAllStringsContainCharacter(groupDeclarationForms, (char) c))
                .count();
    }

    private static boolean doesAllStringsContainCharacter(List<String> strings, char character) {
        return strings.stream().allMatch(string -> string.indexOf(character) >= 0);
    }

    private Day6() { }
}
