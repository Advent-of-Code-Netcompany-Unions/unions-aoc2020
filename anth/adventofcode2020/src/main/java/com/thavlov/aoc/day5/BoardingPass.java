package com.thavlov.aoc.day5;

public class BoardingPass {
    private final String bsp;

    public BoardingPass(String bsp) {
        this.bsp = bsp;
    }

    public int getBoardingPassId() {
        final String rowSpecifier = bsp.substring(0, 7);
        final String columnSpecifier = bsp.substring(7);

        int rowNumber = getRowNumber(rowSpecifier);
        int columnNumber = getColumnNumber(columnSpecifier);

        return rowNumber * 8 + columnNumber;
    }

    private int getRowNumber(String rowSpecifier) {
        int rowMin = 0;
        int rowMax = 127;

        for (char c : rowSpecifier.toCharArray()) {
            if (c == 'B') {
                rowMin = rowMin + (rowMax - rowMin) / 2 + 1;
            } else if (c == 'F') {
                rowMax = rowMax - (rowMax - rowMin) / 2 - 1;
            } else {
                throw new IllegalArgumentException();
            }
        }
        return rowMin;
    }

    private int getColumnNumber(String columnSpecifier) {
        int columnMin = 0;
        int columnMax = 7;

        for (char c : columnSpecifier.toCharArray()) {
            if (c == 'R') {
                columnMin = columnMin + (columnMax - columnMin) / 2 + 1;
            } else if (c == 'L') {
                columnMax = columnMax - (columnMax - columnMin) / 2 - 1;
            } else {
                throw new IllegalArgumentException();
            }
        }
        return columnMin;
    }
}
