package com.wismann.aoc.day8;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) throws IOException {
        System.out.println(solveFirstProblem());
        System.out.println(solveSecondProblem());
    }


    private static int solveSecondProblem() throws IOException {
        Command[] commands = getCommands();


        for (int i = 0; i < commands.length; i++) {
            if (commands[i].getCommand().equals("nop")) {
                commands[i] = new Command("jmp", commands[i].getValue());
            }
            else if (commands[i].getCommand().equals("jmp")) {
                commands[i] = new Command("nop", commands[i].getValue());
            }

            int result = runProgram(commands);
            if (result != -1) {
                return result;
            }

            commands = getCommands();
        }

        return -1;
    }

    private static int runProgram(Command[] commands) {
        Set<Integer> doneCommands = new HashSet<>();

        int acc = 0;
        int nextCommand = 0;

        while (!doneCommands.contains(nextCommand)) {
            if (nextCommand == commands.length) {
                return acc;
            }

            String command = commands[nextCommand].getCommand();
            int val = commands[nextCommand].getValue();

            if (command.equals("acc")) {
                acc+=val;
                doneCommands.add(nextCommand);
                nextCommand++;
                continue;
            }
            if (command.equals("jmp")) {
                doneCommands.add(nextCommand);
                nextCommand+=val;
                continue;
            }
            if (command.equals("nop")) {
                doneCommands.add(nextCommand);
                nextCommand++;
                continue;
            }
        }

        return -1;
    }



    private static Command[] getCommands() throws IOException {
        String filename = "resources/day8.txt";

        List<String> lines = Files.lines(Paths.get(filename))
                .collect(Collectors.toList());
        Command[] commands = new Command[lines.size()];

        for (int i = 0; i < lines.size(); i++) {
            String[] s = lines.get(i).split(" ");
            String command = s[0];
            int val = Integer.parseInt(s[1]);
            commands[i] = new Command(command, val);
        }

        return commands;
    }



    private static int solveFirstProblem() throws IOException {
        Command[] commands = getCommands();

        Set<Integer> doneCommands = new HashSet<>();

        int acc = 0;

        int nextCommand = 0;
        while (!doneCommands.contains(nextCommand)) {
            String command = commands[nextCommand].getCommand();
            int val = commands[nextCommand].getValue();

            if (command.equals("acc")) {
                acc+=val;
                doneCommands.add(nextCommand);
                nextCommand++;
                continue;
            }
            if (command.equals("jmp")) {
                doneCommands.add(nextCommand);
                nextCommand+=val;
                continue;
            }
            if (command.equals("nop")) {
                doneCommands.add(nextCommand);
                nextCommand++;
                continue;
            }
        }

        return acc;

    }

}
