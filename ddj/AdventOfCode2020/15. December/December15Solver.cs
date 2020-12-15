using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _15._December
{
    class December15Solver : ChallengeSolver
    {
        private Dictionary<long, (int, int)> Memory;
        private long LastNumberSpoken;

        public override async Task Solve(string filename)
        {           
            var input = await InputHelper.ReadStrings(filename);
            var startingNumbers = input.First().Split(",").Select(long.Parse).ToList();

            Console.WriteLine($"Res1: {Run(startingNumbers, 2020)}");
            Console.WriteLine($"Res2: {Run(startingNumbers, 30000000)}");           
        }

        public long Run(List<long> startingNumbers, int targetTurn)
        {
            Memory = new Dictionary<long, (int, int)>();

            var turn = 1;
            while (turn <= startingNumbers.Count)
            {
                LastNumberSpoken = startingNumbers[turn - 1];
                Memory[LastNumberSpoken] = (turn, -1);
                turn++;
            }

            while (turn <= targetTurn)
            {
                TakeTurn(turn);
                turn++;
            }

            return LastNumberSpoken;
        }

        public void Say(long num, int turn)
        {
            LastNumberSpoken = num;

            if (Memory.ContainsKey(num))
            {
                var temp = Memory[num];
                Memory[num] = (turn, temp.Item1);
            }
            else
            {
                Memory[num] = (turn, -1);
            }
            
        }

        public void TakeTurn(int turn)
        {
            if (Memory.ContainsKey(LastNumberSpoken))
            {
                var numberInfo = Memory[LastNumberSpoken];
                if (numberInfo.Item2 > 0)
                {
                    Say(numberInfo.Item1 - numberInfo.Item2, turn);
                    return;
                }
            }
            Say(0, turn);
        }        
    }
}
