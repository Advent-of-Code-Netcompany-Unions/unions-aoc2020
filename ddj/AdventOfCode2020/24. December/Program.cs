using System.Threading.Tasks;

namespace _24._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December24Solver();
            await solver.Run();
        }
    }
}
