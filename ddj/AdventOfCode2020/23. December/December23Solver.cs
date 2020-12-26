using AoCLib;
using AoCLib.CircularList;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace _23._December
{
    class December23Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.ReadStrings(filename)).First().ToCharArray().Select(c => int.Parse($"{c}")).ToArray();

            var minVal = input.Min();
            var maxVal = input.Max();
            var cupList = new CircularList<int>(input);
            
            for(var i = 0; i < 100; i++)
            {
                PerformRound(cupList, minVal, maxVal);
            }

            cupList.Find(1);
            cupList.Next();
            var res1 = cupList.ToIEnumerable().Aggregate("", (s, i) => s + $"{i}").Remove(input.Length - 1);
            Console.WriteLine($"Res1: {res1}");

            maxVal = 1000000;
            var vals = Enumerable.Range(1, maxVal).ToArray();
            for(var i = 0; i < input.Length; i++)
            {
                vals[i] = input[i];
            }

            cupList = new CircularList<int>(vals);

            for (var i = 0; i < 10000000; i++)
            {
                PerformRound(cupList, minVal, maxVal);
            }

            cupList.Find(1);
            cupList.Next();
            var res = cupList.Take(2);
            long res2 = (long) res[0] * res[1];

            Console.WriteLine($"Res2: {res2}");
        }

        private void PerformRound(CircularList<int> cupList, int minVal, int maxVal)
        {
            var current = cupList.Current();
            cupList.Next();
            var taken = cupList.Take(3);
            var dest = current == 1 ? maxVal : current - 1;
            while (taken.Contains(dest))
            {
                dest--;
                if (dest < minVal)
                {
                    dest = maxVal;
                }
            }
            cupList.Find(dest);
            taken.Reverse();
            cupList.AddAfter(taken);
            cupList.Find(current);
            cupList.Next();
        }
    }
}
