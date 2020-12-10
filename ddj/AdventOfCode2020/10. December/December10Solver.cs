using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _10._December
{
    class December10Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.ReadLongs(filename)).OrderBy(x => x);

            var current = 0L; //Ha!
            var diffs = new Dictionary<long, int>();

            foreach(var adapter in input)
            {
                var diff = adapter - current;
                if(!diffs.ContainsKey(diff))
                {
                    diffs[diff] = 0;
                }
                current = adapter;
                diffs[diff]++;
            }

            diffs[3]++; //Device itself
            Console.WriteLine($"Res1: {diffs[1] * diffs[3]}");

            var descendingAdapters = input.Reverse().Append(0L);
            var connectionCounts = new Dictionary<long, long>();
            connectionCounts[descendingAdapters.First()] = 1L; //Device can only be connected to last adapter
            foreach (var adapter in descendingAdapters.Skip(1))
            {
                var options = connectionCounts.Where(pair => adapter + 3 >= pair.Key).Select(pair => pair.Value).Sum();
                connectionCounts[adapter] = options;
            }

            var res2 = connectionCounts[0];
            Console.WriteLine($"Res2: {res2}");
        }
    }
}
