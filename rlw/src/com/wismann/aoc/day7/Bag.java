package com.wismann.aoc.day7;

import java.util.Map;

public class Bag {
    private final String bagColor;

    private Map<Bag, Integer> containedBags;

    public Bag(String bagColor) {
        this.bagColor = bagColor;
    }

    public String getBagColor() {
        return bagColor;
    }

    public void setContainedBags(Map<Bag, Integer> containedBags) {
        this.containedBags = containedBags;
    }

    public boolean containsShinyBag() {
        return containedBags.keySet().stream()
                .anyMatch(cb -> cb.containsShinyBag() || cb.getBagColor().equals("shiny gold"));
    }

    public int countSubBags() {
        int directSubBagCount = containedBags.values().stream()
                .reduce(0, (i1, i2) -> i1 + i2);

        int nextLevelSubBagCount = containedBags.entrySet().stream()
                .map(e -> e.getKey().countSubBags() * e.getValue())
                .reduce(0, (i1, i2) -> i1 + i2);

        return directSubBagCount + nextLevelSubBagCount;
    }
}
