package com.wismann.aoc.day8;

public class Command {

    private final String command;

    private final int value;

    public Command(String command, int value) {
        this.command = command;
        this.value = value;
    }

    public String getCommand() {
        return command;
    }

    public int getValue() {
        return value;
    }
}
