using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _5._December
{
    class December5Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadStrings(filename);

            var rows = Enumerable.Range(0, 128);
            var columns = Enumerable.Range(0, 8);

            var found = new List<int>();

            var highest = 0;

            foreach (var line in input)
            {
                var directions = line.Replace('R', 'B');
                var rowDirections = directions.Take(7);
                var columnDirections = directions.Skip(7).Take(3);

                var row = Search(rows, rowDirections);
                var column = Search(columns, columnDirections);

                var sum = row * 8 + column;

                if (sum > highest)
                {
                    highest = sum;
                }

                found.Add(sum);
            }

            var i = 1;
            var mySeat = -1;
            found.Sort();

            while (i < found.Count)
            {
                var cand = found[i];
                if (found[i] - found[i - 1] == 2)
                {
                    mySeat = cand - 1;
                }
                i++;
            }

            Console.WriteLine($"Res 1: {highest}");
            Console.WriteLine($"Res 2: {mySeat}");
        }

        private int Search(IEnumerable<int> toSearch, IEnumerable<char> directions)
        {
            var relevant = toSearch;

            foreach (var direction in directions)
            {
                var slice = relevant.Count() / 2;
                relevant = direction == 'B' ? relevant.Skip(slice) : relevant.Take(slice);
            }

            return relevant.FirstOrDefault();
        }
    }
}
