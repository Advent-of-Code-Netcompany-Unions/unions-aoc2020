using System.Threading.Tasks;

namespace _20._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December20Solver();
            await solver.Run();
        }
    }
}
