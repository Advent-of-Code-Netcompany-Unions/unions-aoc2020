using System;
using System.Diagnostics;
using System.Threading.Tasks;

namespace _15._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December15Solver();
            await solver.Run();

            Console.WriteLine($"Ok, now run optimized version...");
            var stopWatch = new Stopwatch();
            stopWatch.Start();
            var res1 = OptimizedSolve(2020);
            var res2 = OptimizedSolve(30000000);            
            stopWatch.Stop();
            Console.WriteLine($"Found result: {res1} to part 1 and {res2} to part 2 in: {stopWatch.ElapsedMilliseconds} ms.");
            Console.WriteLine();
        }

        static long OptimizedSolve(int targetTurn)
        {
            var shortMemory = new int[targetTurn];            
            var longMemory = new int[targetTurn];            

            /*Abusing input being small enough to manually set up*/
            //1,0,18,10,19,6
            shortMemory[1] = 1;
            shortMemory[0] = 2;
            shortMemory[18] = 3;
            shortMemory[10] = 4;
            shortMemory[19] = 5;
            shortMemory[6] = 6;
            var lastNumberSpoken = 6;

            var turn = 7;
            while (turn <= targetTurn)
            {
                var longMemoryVal = longMemory[lastNumberSpoken];
                if (longMemoryVal > 0)
                {
                    lastNumberSpoken = shortMemory[lastNumberSpoken] - longMemoryVal;
                    longMemory[lastNumberSpoken] = shortMemory[lastNumberSpoken];
                    shortMemory[lastNumberSpoken] = turn;
                    turn++;
                    continue;
                }
                lastNumberSpoken = 0;
                longMemory[0] = shortMemory[0];
                shortMemory[0] = turn;
                turn++;
            }

            return lastNumberSpoken;
        }      
    }
}
