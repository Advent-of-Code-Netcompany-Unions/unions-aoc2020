using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _6._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var filename = InputHelper.GetFilename(args);
            var inputGroups = await InputHelper.GetStringsGroupedByEmptyLine(filename);

            var answerSets = inputGroups.Select(group => group.Select(answer => (IEnumerable<char>) answer));
            var union = answerSets.Select(answers => answers.Aggregate((current, next) => current.Union(next)));
            var intersect = answerSets.Select(answers => answers.Aggregate((current, next) => current.Intersect(next)));
                        
            var unionSum = union.Sum(a => a.Count());
            var intersectSum = intersect.Sum(a => a.Count());

            Console.WriteLine($"Res 1: {unionSum}");
            Console.WriteLine($"Res 2: {intersectSum}");
        }
    }
}
