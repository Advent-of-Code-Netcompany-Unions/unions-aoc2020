using AoCLib;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace _3._December
{
    class December3Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadStrings(filename);

            var map = new Map(input);
            var slopes = new List<ValueTuple<int, int>>() { (3, 1), (1, 1), (5, 1), (7, 1), (1, 2) };

            var result1 = map.TreesOnSlope(slopes[0]);

            Console.WriteLine($"Result of question 1 is: {result1}");

            long runningProduct = 1;
            foreach (var slope in slopes)
            {
                runningProduct *= map.TreesOnSlope(slope);
            }

            Console.WriteLine($"Result of question 2 is: {runningProduct}");
        }
    }
}
