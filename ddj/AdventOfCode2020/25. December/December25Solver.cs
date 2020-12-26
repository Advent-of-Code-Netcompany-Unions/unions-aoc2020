using AoCLib;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace _25._December
{
    class December25Solver : ChallengeSolver
    {
        private const long Modulo = 20201227L;

        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadLongs(filename);
            var firstKey = input.First();
            var secondKey = input.Last();
            var subjectNumber = 7L;

            var loop1size = 0L;
            var loop2size = 0L;
            var i = 1L;
            var runningVal = 1L;
            var firstLoopFound = false;
            var secondLoopFound = false;
            while(!firstLoopFound || !secondLoopFound)
            {
                runningVal *= subjectNumber;
                runningVal %= Modulo;

                if(runningVal == firstKey)
                {
                    loop1size = i;
                    firstLoopFound = true;
                    Console.WriteLine($"Determined loop 1 size to: {i}");
                }

                if(runningVal == secondKey)
                {
                    loop2size = i;
                    secondLoopFound = true;
                    Console.WriteLine($"Determined loop 2 size to: {i}");
                }

                i++;
            }

            var encryptionKeyV1 = Transform(firstKey, loop2size);
            var encryptionKeyV2 = Transform(secondKey, loop1size);

            if(encryptionKeyV1 != encryptionKeyV2)
            {
                throw new Exception("Key mismatch");
            }

            Console.WriteLine($"Res1: {encryptionKeyV1}");
        }

        private long Transform(long subjectNumber, long loopSize)
        {
            var runningVal = 1L;
            for(var i = 0; i < loopSize; i++)
            {
                runningVal *= subjectNumber;
                runningVal %= Modulo;
            }

            return runningVal;
        }
    }
}
