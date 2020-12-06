package com.thavlov.aoc;

import com.thavlov.aoc.day1.Day1Ex1;
import com.thavlov.aoc.day1.Day1Ex2;
import com.thavlov.aoc.day2.Day2Ex1;
import com.thavlov.aoc.day2.Day2Ex2;
import com.thavlov.aoc.day3.Day3Ex1;
import com.thavlov.aoc.day3.Day3Ex2;
import com.thavlov.aoc.day4.Day4Ex1;
import com.thavlov.aoc.day4.Day4Ex2;
import com.thavlov.aoc.day5.Day5;
import com.thavlov.aoc.day6.Day6;

public class AdventOfCode2020 {
    public static void main(String[] args) throws Exception {
        System.out.println("Advent of Code 2020:");

        long t = System.currentTimeMillis();

        System.out.println(" > Solution 1 to day 1: " + Day1Ex1.solve());
        System.out.println(" > Solution 2 to day 1: " + Day1Ex2.solve());

        System.out.println(" > Solution 1 to day 2: " + Day2Ex1.solve());
        System.out.println(" > Solution 2 to day 2: " + Day2Ex2.solve());

        System.out.println(" > Solution 1 to day 3: " + Day3Ex1.solve());
        System.out.println(" > Solution 2 to day 3: " + Day3Ex2.solve());

        System.out.println(" > Solution 1 to day 4: " + Day4Ex1.solve());
        System.out.println(" > Solution 2 to day 4: " + Day4Ex2.solve());

        System.out.println(" > Solution 1 to day 5: " + Day5.solvePart1());
        System.out.println(" > Solution 2 to day 5: " + Day5.solvePart2());

        System.out.println(" > Solution 1 to day 6: " + Day6.solvePart1());
        System.out.println(" > Solution 2 to day 6: " + Day6.solvePart2());

        System.out.printf("Execution time: %d ms.%n", (System.currentTimeMillis() - t));
    }
}
