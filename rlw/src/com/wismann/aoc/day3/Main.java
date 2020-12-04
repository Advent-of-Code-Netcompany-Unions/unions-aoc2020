package com.wismann.aoc.day3;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {

        String filename = "resources/day3.txt";

        System.out.println(solveFirstProblem(filename));
        System.out.println(solveSecondProblem(filename));

    }

    private static long solveFirstProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        int forrestHeight = lines.size();
        int forrestWidth = lines.get(0).toCharArray().length;

        int[][] forrestMap = new int[forrestHeight][forrestWidth];

        for (int y = 0; y < forrestHeight; y++) {
            for(int x = 0; x < forrestWidth; x++) {
                forrestMap[y][x] = lines.get(y).toCharArray()[x] == 35 ? 1 : 0;
            }
        }

        return solve(forrestMap, 3, 1);
    }

    private static long solveSecondProblem(String inputFile) throws IOException {
        List<String> lines = Files.lines(Paths.get(inputFile))
                .collect(Collectors.toList());

        int forrestHeight = lines.size();
        int forrestWidth = lines.get(0).toCharArray().length;

        int[][] forrestMap = new int[forrestHeight][forrestWidth];

        for (int y = 0; y < forrestHeight; y++) {
            for(int x = 0; x < forrestWidth; x++) {
                forrestMap[y][x] = lines.get(y).toCharArray()[x] == 35 ? 1 : 0;
            }
        }

        return solve(forrestMap, 1, 1) *
                solve(forrestMap, 3,1) *
                solve(forrestMap, 5, 1) *
                solve(forrestMap, 7,1) *
                solve(forrestMap, 1,2);
    }

    private static boolean checkIfTree(int[][] forrestMap, int x, int y) {
        return forrestMap[y][x] == 1;
    }


    private static long solve(int[][] forrestMap, int xSpeed, int ySpeed) {
        int treeCount = 0;
        int x = 0;
        int y = 0;

        while (y < forrestMap.length-1) {
            y = y + ySpeed;
            x = (x+xSpeed) % forrestMap[y].length;

            if (checkIfTree(forrestMap, x, y)) {
                treeCount++;
            }
        }

        return treeCount;
    }

}
