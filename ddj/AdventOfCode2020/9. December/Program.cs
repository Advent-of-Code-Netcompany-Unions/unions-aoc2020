using System.Threading.Tasks;

namespace _9._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December9Solver();
            await solver.Run();
        }
    }
}
