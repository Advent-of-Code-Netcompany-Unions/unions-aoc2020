using System.Threading.Tasks;

namespace _16._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December16Solver();
            await solver.Run();
        }
    }
}
