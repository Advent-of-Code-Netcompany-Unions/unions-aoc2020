package com.wismann.aoc.day7;

import java.util.Map;

public class Bag {
    private String bagColor;

    private Map<Bag, Integer> containedBags;

    public Bag(String bagColor) {
        this.bagColor = bagColor;
    }

    public String getBagColor() {
        return bagColor;
    }

    public Map<Bag, Integer> getContainedBags() {
        return containedBags;
    }

    public void setBagColor(String bagColor) {
        this.bagColor = bagColor;
    }

    public void setContainedBags(Map<Bag, Integer> containedBags) {
        this.containedBags = containedBags;
    }
}
