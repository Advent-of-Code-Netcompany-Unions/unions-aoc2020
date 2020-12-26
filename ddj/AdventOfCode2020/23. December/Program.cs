using System.Threading.Tasks;

namespace _23._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December23Solver();
            await solver.Run();
        }
    }
}
