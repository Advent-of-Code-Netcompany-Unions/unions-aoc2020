using AoCLib;
using System;
using System.Threading.Tasks;

namespace _1._December
{
    class Program
    {       
        static async Task Main(string[] args)
        {
            var filename = InputHelper.GetFilename(args);
            var input = await InputHelper.ReadInts(filename);

            var solver = new December1Solver(input, 2020, 2);
            var res1 = solver.Solve();

            Console.WriteLine($"First result for 1. December is: {res1}");

            solver = new December1Solver(input, 2020, 3);
            var res2 = solver.Solve();

            Console.WriteLine($"Second result for 1. December is: {res2}");
        }
    }
}
