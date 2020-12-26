using System.Threading.Tasks;

namespace _22._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December22Solver();
            await solver.Run();
        }
    }
}
