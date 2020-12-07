package com.wismann.aoc.day7;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String filename = "resources/day7.txt";

        createBags(filename);
    }

    private static void createBags(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        List<Bag> bags = lines.stream()
                .map(l -> l.split("bags")[0].trim())
                .map(Bag::new)
                .collect(Collectors.toList());

       lines.forEach(l -> setContainedBags(bags, l));
    }

    private static void setContainedBags(List<Bag> bags, String inputLine) {

        String mainBagColor = inputLine.split("bags")[0].trim();
        Bag mainBag = bags.stream().filter(b -> b.getBagColor().equals(mainBagColor)).findFirst().orElseThrow();

        String[] contains = inputLine.split("contain")[1].trim().split(",");
        List<String> containedBagStrings = Arrays.stream(contains)
                .map(s -> s.replaceAll("\\.", ""))
                .map(s -> s.replaceAll("bags", ""))
                .map(String::trim)
                .collect(Collectors.toList());
    }

}
