package com.thavlov.aoc.day8;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class GameConsole {
    private final List<Operation> instructionSet;

    private GameConsole(List<Operation> instructionSet) {
        this.instructionSet = instructionSet;
    }

    static GameConsole loadFromFile(final String fileLocation) throws IOException, URISyntaxException {
        URL url = Optional.ofNullable(GameConsole.class.getClassLoader().getResource(fileLocation))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", fileLocation)));

        Path path = Paths.get(url.toURI());
        final List<Operation> operations;
        try (Stream<String> linesFromFile = Files.lines(path)) {
            operations = linesFromFile.map(Operation::parseFromString).collect(Collectors.toList());
        }

        return new GameConsole(operations);
    }

    public List<Integer> getIndicesWithJmpAndNop() {
        List<Integer> result = new ArrayList<>();
        for (int i = 0; i < instructionSet.size(); i++) {
            if (!instructionSet.get(i).getOperationType().equalsIgnoreCase("acc")) {
                result.add(i);
            }
        }
        return result;

    }

    public int runApplication() {
        int index = 0;
        int accumulator = 0;
        List<Integer> indicesVisited = new ArrayList<>();

        while (true) {
            indicesVisited.add(index);
            Operation operation = instructionSet.get(index);
            switch (operation.getOperationType()) {
                case "acc":
                    accumulator += operation.getValue();
                    index++;
                    break;
                case "jmp":
                    index += operation.getValue();
                    break;
                case "nop":
                    index++;
                    break;
            }
            if (indicesVisited.contains(index)) {
                return accumulator;
            }
        }
    }

    public int runApplicationWithFlipIndex(int inxdexToFlip) {
        int index = 0;
        int accumulator = 0;
        List<Integer> indicesVisited = new ArrayList<>();

        while (true) {
            indicesVisited.add(index);
            Operation operation = instructionSet.get(index);
            String operationToPerform = operation.getOperationType();

            if (inxdexToFlip == index) {
                if (operationToPerform.equalsIgnoreCase("nop")) {
                    operationToPerform = "jmp";
                } else if (operationToPerform.equalsIgnoreCase("jmp")) {
                    operationToPerform = "nop";
                }
            }

            switch (operationToPerform) {
                case "acc":
                    accumulator += operation.getValue();
                    index++;
                    break;
                case "jmp":
                    index += operation.getValue();
                    break;
                case "nop":
                    index++;
                    break;
            }
            if (index == instructionSet.size()) {
                return accumulator;
            }
            if (indicesVisited.contains(index)) {
                return Integer.MIN_VALUE;
            }
        }
    }

    private static class Operation {
        private static final String REGEX = "(.*) ([+|-][0-9]+)";
        private static final Pattern PATTERN = Pattern.compile(REGEX);

        private final String operationType;
        private final int value;

        private Operation(String operationType, int value) {
            this.operationType = operationType;
            this.value = value;
        }

        static Operation parseFromString(String line) {
            Matcher matcher = PATTERN.matcher(line);
            matcher.find();
            return new Operation(matcher.group(1), Integer.parseInt(matcher.group(2)));

        }

        public String getOperationType() {
            return operationType;
        }

        public int getValue() {
            return value;
        }
    }
}
