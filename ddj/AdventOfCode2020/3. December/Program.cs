using System.Threading.Tasks;

namespace _3._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December3Solver();
            await solver.Run();
        }
    }
}
