using System.Threading.Tasks;

namespace _14._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December14Solver();
            await solver.Run();
        }
    }
}
