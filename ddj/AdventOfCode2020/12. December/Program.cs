using System.Threading.Tasks;

namespace _12._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December12Solver();
            await solver.Run();
        }
    }
}
