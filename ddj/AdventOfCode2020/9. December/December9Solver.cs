using AoCLib;
using _1._December;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace _9._December
{
    class December9Solver : ChallengeSolver
    {
        private int PreambleSize { get; set; } = 5;

        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.ReadLongs(filename)).ToArray();

            //Uuuuuggghh
            if(filename == "input.txt")
            {
                PreambleSize = 25;
            }

            var inputPointer = PreambleSize;
            var preamblePointer = 0;
            long? invalidNum = null;

            while(inputPointer < input.Length)
            {
                var prevNums = input.Skip(preamblePointer).Take(PreambleSize).OrderBy(x => x).ToList();
                var numberSolver = new December1Solver(prevNums, input[inputPointer], 2);

                if(numberSolver.Solve() == null)
                {
                    invalidNum = input[inputPointer];
                    Console.WriteLine($"Res1: {invalidNum}");
                }

                preamblePointer++;
                inputPointer++;
            }

            var i = 0;
            var j = 1;
            var runningSum = input[i] + input[j];
            while(i < input.Length)
            {
                if(runningSum < invalidNum && j < input.Length)
                {
                    j++;
                    runningSum += input[j];
                    continue;
                }
                else if(runningSum == invalidNum)
                {
                    Console.WriteLine($"Found match from index {i} to index {j}.");
                    var seq = input.Skip(i).Take(j - i + 1);
                    var res = seq.Min() + seq.Max();
                    Console.WriteLine($"Res2: {res}");
                    break;
                }
                else
                {
                    i++;
                    j = i + 1;
                   runningSum = input[i] + input[j];
                }
            }            
        }
    }
}
