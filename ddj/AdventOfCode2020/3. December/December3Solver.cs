using AoCLib;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace _3._December
{
    class December3Solver : ChallengeSolver
    {
        private Grid2D<char> Map;

        public override async Task Solve(string filename)
        {
            var slopes = new List<ValueTuple<int, int>>() { (3, 1), (1, 1), (5, 1), (7, 1), (1, 2) };

            var input = await InputHelper.GetTwoDimensionalArray(filename);
            Map = new Grid2D<char>(input);            

            var result1 = TreesOnSlope(slopes[0]);

            Console.WriteLine($"Result of question 1 is: {result1}");

            long runningProduct = 1;
            foreach (var slope in slopes)
            {
                runningProduct *= TreesOnSlope(slope);
            }

            Console.WriteLine($"Result of question 2 is: {runningProduct}");
        }

        private int TreesOnSlope((int deltaX, int deltaY) slope)
        {
            var count = 0;
            var index = (x: 0, y: 0);
            while (index.y < Map.Height)
            {
                if (SquareHasTree(index.x, index.y))
                {
                    count++;
                }

                index = (index.x + slope.deltaX, index.y + slope.deltaY);
            }

            return count;
        }

        private bool SquareHasTree(int x, int y)
        {
            return Map.Contents[x % Map.Width, y] == '#';
        }
    }
}
