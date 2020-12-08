using System.Threading.Tasks;

namespace _6._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December6Solver();
            await solver.Run();
        }
    }
}
