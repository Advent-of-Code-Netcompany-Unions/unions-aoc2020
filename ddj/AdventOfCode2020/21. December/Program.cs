using System.Threading.Tasks;

namespace _21._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December21Solver();
            await solver.Run();
        }
    }
}
