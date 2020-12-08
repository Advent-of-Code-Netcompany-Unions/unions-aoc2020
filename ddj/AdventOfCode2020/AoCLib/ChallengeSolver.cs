using System;
using System.Threading.Tasks;

namespace AoCLib
{
    public abstract class ChallengeSolver
    {
        public async Task Run()
        {
            Console.WriteLine("Solving example...");
            await SolveInternal("example.txt");
            Console.WriteLine();
            Console.WriteLine("Solving for input...");
            await SolveInternal("input.txt");            
        }

        private async Task SolveInternal(string filename)
        {
            try
            {
               await Solve(filename);
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Encountered error: {ex}");
            }
        }

        public abstract Task Solve(string filename);
    }
}
