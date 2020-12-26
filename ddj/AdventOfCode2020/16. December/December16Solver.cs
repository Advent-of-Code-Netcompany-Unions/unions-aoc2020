using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _16._December
{
    class December16Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.GetStringsGroupedByEmptyLine(filename)).ToList();

            var ticketInfo = new TicketInfo(input[0]);

            var otherTickets = ParseTicketSection(input[2]);
            (var scanErrorRate, var validTickets) = ValidateTickets(otherTickets, ticketInfo);
             
            Console.WriteLine($"Res1: {scanErrorRate}");

            var potentialMatches = new Dictionary<int, HashSet<string>>();
            foreach(var ticket in validTickets)
            {
                for(var i = 0; i < ticket.Count; i++)
                {
                    var matches = FindMatchingFields(ticket[i], ticketInfo);

                    if(potentialMatches.ContainsKey(i))
                    {
                        potentialMatches[i] = potentialMatches[i].Intersect(matches).ToHashSet();
                    }
                    else
                    {
                        potentialMatches[i] = matches;
                    }
                }
            }

            //This assumes that there's always (at least) one index remaining which we can map with perfect certainty            
            var finalMap = new Dictionary<string, int>();
            while(potentialMatches.Any(match => match.Value.Count == 1))
            {
                var toUpdate = potentialMatches.First(match => match.Value.Count == 1);
                var className = toUpdate.Value.First();
                if (finalMap.ContainsKey(className))
                {
                    throw new Exception("Duplicate mapping");
                }
                finalMap[className] = toUpdate.Key;

                foreach(var match in potentialMatches)
                {
                    match.Value.Remove(className);
                }
            }

            var myTicket = ParseTicketSection(input[1]).First().ToList();

            Console.WriteLine("My ticket:");

            var departureProduct = 1L;
            foreach(var val in finalMap)
            {
                var ticketVal = myTicket[val.Value];
                Console.WriteLine($"{val.Key}: {ticketVal}");

                if(val.Key.StartsWith("departure"))
                {
                    departureProduct *= ticketVal;
                }
            }

            Console.WriteLine();

            Console.WriteLine($"Res 2 answer: {departureProduct}");
            Console.WriteLine();
        }

        private (long ScanErrorRate, List<List<long>> ValidTickets) ValidateTickets(IEnumerable<IEnumerable<long>> tickets, TicketInfo info)
        {
            var validTickets = new List<List<long>>();
            var scanErrorRate = 0L;
            foreach (var ticket in tickets)
            {
                var valid = true;

                foreach (var val in ticket)
                {
                    if (!info.IsValidNumber(val))
                    {
                        scanErrorRate += val;
                        valid = false;
                    }
                }

                if (valid)
                {
                    validTickets.Add(ticket.ToList());
                }
            }

            return (scanErrorRate, validTickets);
        }

        private IEnumerable<IEnumerable<long>> ParseTicketSection(IEnumerable<string> ticketData)
        {
            return ticketData
                .Skip(1) //Header
                .Select(s => s.Split(","))
                .Select(ticketData => ticketData.Select(long.Parse));            
        }

        private HashSet<string> FindMatchingFields(long val, TicketInfo info)
        {
            return info.Classes
                        .Where(pair => pair.Value
                                                .Any(interval => TicketInfo.InInterval(val, interval)))
                        .Select(pair => pair.Key)
                        .ToHashSet();
        }
    }

    class TicketInfo
    {
        public Dictionary<string, List<(long Min, long Max)>> Classes = new Dictionary<string, List<(long, long)>>();

        public TicketInfo(IEnumerable<string> classSpecs)
        {
            foreach(var classSpec in classSpecs)
            {
                var parts = classSpec.Split(":");
                var name = parts[0];
                
                var intervals = new List<(long Min, long Max)>();
                var intervalsToParse = parts[1].Split(" or ");
                foreach(var interval in intervalsToParse)
                {
                    var intervalParts = interval.Split("-");
                    intervals.Add((long.Parse(intervalParts[0]), long.Parse(intervalParts[1])));
                }

                Classes.Add(name, intervals);                    
            }
        }

        public static bool InInterval(long num, (long Min, long Max) interval)
        {
            return num >= interval.Min && num <= interval.Max;
        }

        public bool IsValidNumber(long num)
        {
            var intervalsToCheck = Classes.Values.SelectMany(pair => pair);
            return intervalsToCheck.Any(interval => InInterval(num, interval));
        }
    }    
}
