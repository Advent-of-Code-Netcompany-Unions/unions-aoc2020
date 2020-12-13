using System.Threading.Tasks;

namespace _13._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December13Solver();
            await solver.Run();
        }
    }
}
