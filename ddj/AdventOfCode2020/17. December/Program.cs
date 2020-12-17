using System.Threading.Tasks;

namespace _17._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December17Solver();
            await solver.Run();
        }
    }
}
