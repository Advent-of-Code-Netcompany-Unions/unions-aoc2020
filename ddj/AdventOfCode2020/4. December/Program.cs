using System.Threading.Tasks;

namespace _4._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December4Solver();
            await solver.Run();
        }
    }
}
