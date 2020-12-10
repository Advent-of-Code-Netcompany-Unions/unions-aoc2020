using System.Threading.Tasks;

namespace _10._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December10Solver();
            await solver.Run();
        }
    }
}
