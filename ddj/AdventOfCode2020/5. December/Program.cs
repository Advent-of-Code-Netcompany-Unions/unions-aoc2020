using System.Threading.Tasks;

namespace _5._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December5Solver();
            await solver.Run();
        }
    }
}
