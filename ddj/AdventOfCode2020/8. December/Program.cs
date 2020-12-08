using System.Threading.Tasks;

namespace _8._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var solver = new December8Solver();
            await solver.Run();
        }
    }    
}
