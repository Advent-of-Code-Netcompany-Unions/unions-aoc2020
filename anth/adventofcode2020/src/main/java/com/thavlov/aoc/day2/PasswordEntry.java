package com.thavlov.aoc.day2;

import java.util.StringTokenizer;

class PasswordEntry {
    final int index1;
    final int index2;
    final char character;
    final String password;

    private PasswordEntry(int index1, int index2, char character, String password) {
        this.index1 = index1;
        this.index2 = index2;
        this.character = character;
        this.password = password;
    }

    static PasswordEntry fromString(String line) {
        line = line.replace("-", " ").replace(":", "");
        StringTokenizer stringTokenizer = new StringTokenizer(line);
        int index1 = Integer.parseInt(stringTokenizer.nextToken());
        int index2 = Integer.parseInt(stringTokenizer.nextToken());
        char character = stringTokenizer.nextToken().charAt(0);
        String password = stringTokenizer.nextToken();

        return new PasswordEntry(index1, index2, character, password);
    }

    public boolean isValid() {
        return password.charAt(index1-1) == character ^ password.charAt(index2-1) == character;
    }
}