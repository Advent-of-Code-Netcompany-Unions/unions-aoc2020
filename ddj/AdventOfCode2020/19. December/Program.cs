using System.Threading.Tasks;

namespace _19._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December19Solver();
            await solver.Run();
        }
    }
}
