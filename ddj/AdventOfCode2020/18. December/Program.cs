using System.Threading.Tasks;

namespace _18._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December18Solver();
            await solver.Run();
        }
    }
}
