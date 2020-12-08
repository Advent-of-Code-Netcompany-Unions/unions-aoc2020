package com.thavlov.aoc.day7;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Day7 {
    private static final String INPUT_FILE = "./day7/input.txt";
    private static final String MY_BAG_COLOR = "shiny gold";

    private static Map<String, Bag> bagMap;

    private static void init() throws URISyntaxException, IOException {
        URL url = Optional.ofNullable(Day7.class.getClassLoader().getResource(INPUT_FILE))
                .orElseThrow(() -> new IllegalArgumentException(String.format("Unable to locate resource: %s.", INPUT_FILE)));

        Path path = Paths.get(url.toURI());

        try (Stream<String> linesFromFile = Files.lines(path)) {
            bagMap = linesFromFile
                    .map(Bag::parseFromString)
                    .collect(Collectors.toMap(Bag::getBagColor, Function.identity()));
        }
    }

    public static String solvePart1() {
        try {
            init();

            int counter = 0;
            for (String bagId : bagMap.keySet()) {
                if (canBagContainBagOfType(bagId, MY_BAG_COLOR)) {
                    counter++;
                }
            }
            return Integer.toString(counter);
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    public static String solvePart2() {
        try {
            init();

            return Integer.toString(findAggregatedQuantityOfBag(MY_BAG_COLOR) - 1);
        } catch (Exception e) {
            return String.format("Unknown solution due to error: %s", e.getMessage());
        }
    }

    private static boolean canBagContainBagOfType(final String bagColor, final String otherBagType) {
        final Bag bag = bagMap.get(bagColor);
        final List<Bag> bagContent = bag.getContent();

        if (bagContent.isEmpty()) {
            return false;
        }

        if (isBagTypeIncludedInBag(otherBagType, bag)) {
            return true;
        }

        for (Bag bag1 : bagContent) {
            if (canBagContainBagOfType(bag1.getBagColor(), otherBagType)) {
                return true;
            }
        }
        return false;
    }

    private static boolean isBagTypeIncludedInBag(String bagType, Bag bag) {
        return bag.getContent().stream()
                .map(Bag::getBagColor)
                .anyMatch(bagType::equals);
    }

    private static int findAggregatedQuantityOfBag(final String bagColor) {
        final Bag bag = bagMap.get(bagColor);
        final List<Bag> bagContent = bag.getContent();

        if (bagContent.isEmpty()) {
            return 1;
        }

        int sum = 1;
        for (Bag bag1 : bagContent) {
            sum += bag1.getQuantity() * findAggregatedQuantityOfBag(bag1.getBagColor());
        }
        return sum;
    }

    private Day7() { }
}
