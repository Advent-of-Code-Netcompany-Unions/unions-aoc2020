﻿using System.Threading.Tasks;

namespace _7._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December7Solver();
            await solver.Run();
        }
    }
}
