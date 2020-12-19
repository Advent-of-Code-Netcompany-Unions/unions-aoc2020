using AoCLib;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace _18._December
{
    class December18Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadStrings(filename);

            var res1 = input.Select(s => new Calculator(s, false).ComputeResult());
            Console.WriteLine($"Res1: {res1.Sum()}");

            var res2 = input.Select(s => new Calculator(s, true).ComputeResult());
            Console.WriteLine($"Res2: {res2.Sum()}");
        }
    }   
}
