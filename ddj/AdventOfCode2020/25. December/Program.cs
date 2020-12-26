using System.Threading.Tasks;

namespace _25._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December25Solver();
            await solver.Run();
        }
    }
}
