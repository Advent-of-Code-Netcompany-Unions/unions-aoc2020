using System.Threading.Tasks;

namespace _11._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December11Solver();
            await solver.Run();
        }
    }
}
