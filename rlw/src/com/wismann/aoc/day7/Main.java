package com.wismann.aoc.day7;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String filename = "resources/day7.txt";

        List<String> lines = Files.lines(Paths.get(filename))
                .collect(Collectors.toList());

        List<Bag> bags = buildBags(lines);

        System.out.println(solveFirstProblem(bags));
        System.out.println(solveSecondProblem(bags));

    }
    private static long solveSecondProblem(List<Bag> bags) {
        return bags.stream().filter(b -> b.getBagColor().equals("shiny gold")).findFirst().map(Bag::countSubBags).orElse(0);
    }

    private static long solveFirstProblem(List<Bag> bags) {
        return bags.stream().filter(Bag::containsShinyBag).count();
    }

    private static List<Bag> buildBags(List<String> inputLines) {
        List<Bag> bags = inputLines.stream()
                .map(l -> l.split("bags")[0].trim())
                .map(Bag::new)
                .collect(Collectors.toList());

        inputLines.forEach(l -> buildBag(bags, l));

        return bags;
    }


    private static void buildBag(List<Bag> bags, String inputLine) {
        String mainBagColor = inputLine.split("bags")[0].trim();
        Bag mainBag = bags.stream().filter(b -> b.getBagColor().equals(mainBagColor)).findFirst().orElse(null);

        String[] contains = inputLine.split("contain")[1].trim().split(",");
        List<String> containedBagStrings = Arrays.stream(contains)
                .map(s -> s.replaceAll("\\.", ""))
                .map(s -> s.replaceAll("bags", ""))
                .map(String::trim)
                .collect(Collectors.toList());

        Map<Bag, Integer> containedBags = new HashMap<>();

        for (String s : containedBagStrings) {
            if (s.equals("no other")) {
                break;
            }
            String[] split = s.split(" ");
            int amount = Integer.parseInt(split[0]);
            String color = split[1] + " " + split[2];
            Bag bag = bags.stream().filter(b -> b.getBagColor().equals(color)).findFirst().orElse(null);
            containedBags.put(bag, amount);
        }

        mainBag.setContainedBags(containedBags);
    }

}
