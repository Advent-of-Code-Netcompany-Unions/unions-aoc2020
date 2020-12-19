using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.Threading.Tasks;

namespace AoCLib
{
    public abstract class ChallengeSolver
    {
        public async Task Run()
        {
            CultureInfo.CurrentCulture = new CultureInfo("en-us", false);

            foreach(var file in GetInputFiles())
            {
                Console.WriteLine($"Solving {file}...");                
                await SolveInternal(file);                
                
                Console.WriteLine();
            }           
        }

        private async Task SolveInternal(string filename)
        {
            try
            {
                var stopwatch = new Stopwatch();
                stopwatch.Start();
                await Solve(filename);
                stopwatch.Stop();
                Console.WriteLine($"Solved in {stopwatch.ElapsedMilliseconds}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Encountered error: {ex}");
            }
        }

        public abstract Task Solve(string filename);

        public virtual IEnumerable<string> GetInputFiles()
        {
            return new string[] {"example.txt", "input.txt" };
        }
    }
}
