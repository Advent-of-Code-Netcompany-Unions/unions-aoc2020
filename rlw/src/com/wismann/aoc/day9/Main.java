package com.wismann.aoc.day9;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        String filename = "resources/day9.txt";

        List<String> lines = Files.lines(Paths.get(filename))
                .collect(Collectors.toList());

        long[] numbers = new long[lines.size()];

        for (int i = 0; i < lines.size(); i++) {
            numbers[i] = Long.parseLong(lines.get(i));
        }

        System.out.println(solveFirstProblem(numbers));
        System.out.println(solveSecondProblem(numbers));
    }


    private static long solveSecondProblem(long[] numbers) {
        long weaknessNumber = solveFirstProblem(numbers);

        int minIndex = 0;
        int maxIndex = 1;
        while(true) {
            long[] sumArray = new long[maxIndex-minIndex+1];

            for (int i = 0; i < sumArray.length; i++) {
                sumArray[i] = numbers[minIndex+i];
            }

            if(sumNumbersInArray(sumArray) == weaknessNumber) {
                long min = Arrays.stream(sumArray).max().orElse(0L);
                long max = Arrays.stream(sumArray).min().orElse(0L);
                return min + max;
            }

            if (maxIndex < numbers.length-1) {
                maxIndex++;
            }
            else {
                minIndex++;
                maxIndex = minIndex+1;
            }

        }
    }

    private static long sumNumbersInArray(long[] numbers) {
        long res = 0L;
        for (int i = 0; i < numbers.length; i++) {
            res += numbers[i];
        }
        return res;
    }


    private static long solveFirstProblem(long[] numbers) {
        int preamble = 25;

        for (int i = preamble; i < numbers.length; i++) {
            long[] numbersToTest = new long[preamble];

            for (int j = 0; j < numbersToTest.length; j++) {
                numbersToTest[j] = numbers[i-preamble+j];
            }

            if (!isSumOfTwo(numbersToTest, numbers[i])) {
                return numbers[i];
            }
        }

        return -1;

    }

    private static boolean isSumOfTwo(long[] numbers, long numberToTest) {
        for (long i : numbers) {
            for (long j : numbers) {
                if (i+j == numberToTest) {
                    return true;
                }
            }
        }

        return false;
    }



}
