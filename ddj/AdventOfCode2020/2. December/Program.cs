using System.Threading.Tasks;

namespace _2._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December2Solver();
            await solver.Run();
        }
    }
}
