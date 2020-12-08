package com.thavlov.aoc.day7;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Bag {
    private final String bagColor;
    private final int quantity;
    private final List<Bag> content;

    private Bag(String bagColor, int quantity) {
        this(bagColor, quantity, Collections.emptyList());
    }

    private Bag(String bagColor, int quantity, List<Bag> content) {
        this.bagColor = bagColor;
        this.quantity = quantity;
        this.content = content;
    }

    public List<Bag> getContent() {
        return content;
    }

    static Bag parseFromString(final String string) {
        String regex = "(.*) bags contain (.*)";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(string);

        if (!matcher.find()) {
            throw new IllegalStateException("asdsad");
        }

        final String bagColor = matcher.group(1);
        final List<Bag> content = parseSubItems(matcher.group(2));

        return new Bag(bagColor, 1, content);
    }

    private static List<Bag> parseSubItems(final String string) {
        if (string.contains("no other bags.")) {
            return Collections.emptyList();
        }
        final List<Bag> result = new ArrayList<>();
        final String[] split = string.split(", ");
        String regex = "([0-9]*) (.*) bag|bags";
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher;
        for (String s : split) {
            matcher = pattern.matcher(s);
            matcher.find();
            result.add(new Bag(matcher.group(2), Integer.parseInt(matcher.group(1))));
        }
        return result;
    }

    public String getBagColor() {
        return bagColor;
    }

    public int getQuantity() {
        return quantity;
    }
}