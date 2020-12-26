using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Numerics;
using System.Text;
using System.Threading.Tasks;

namespace _13._December
{
    class December13Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.ReadStrings(filename)).ToList();

            Console.WriteLine($"Res1: {SolvePart1(input)}");

            Console.WriteLine($"Res2: {SolvePart2(input)}");
        }

        private long SolvePart1(List<string> input)
        {
            var departure = long.Parse(input[0]);
            var busses = input[1]
                .Split(',')
                .Where(c => c != "x")
                .Select(long.Parse);

            var nextDepartures = busses
                .Select(bus => (id: bus, dep: GetNextDeparture(bus, departure)))
                .OrderBy(bus => bus.dep);

            var (id, dep) = nextDepartures.First();
            var wait = dep - departure;

            Console.WriteLine($"Bus: {id}, Waiting time: {wait}");
            return id * wait;
        }

        private long GetNextDeparture(long id, long now)
        {
            var previous = id * (now / id);
            var next = previous + id;            

            return next;
        }

        private BigInteger SolvePart2(List<string> input)
        {
            var busses = input[1]
                .Split(',')
                .Select((string id, int offset) => (id, offset))
                .Where(entry => entry.id != "x")
                .Select(entry => (id: long.Parse(entry.id), entry.offset))                
                .ToList();

            // If there is a solution, it must repeat with a period shorter than the product of intervals
            var upperBound = busses.Select(b => b.id).Aggregate(1L, (s, i) => s * i);

            var increment = busses[0].id;
            var currentTime = increment + busses[0].offset; //We could start at 10^14 but that seems cheap...
            var nextBusIndex = 1;

            while (currentTime < upperBound && nextBusIndex < busses.Count)
            {
                //Did we find a time where busses 0...i-1 aligns with bus i?
                while ((currentTime + busses[nextBusIndex].offset) % busses[nextBusIndex].id != 0)
                {
                    //No, keep searching
                    currentTime += increment;
                    continue;
                }

                //Found match, since the bus intervals are primes (how convenient), we know they don't match up again before their product
                increment *= busses[nextBusIndex].id;
                nextBusIndex++;
            }

            //If currentTime exceeds upper bound, we didn't find any solutions
            return currentTime < upperBound ? currentTime : -1;
        }
    }
}
