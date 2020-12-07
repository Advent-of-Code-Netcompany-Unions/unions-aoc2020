using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _7._December
{
    class Program
    {
        public static async Task Main(string[] args)
        {
            var filename = InputHelper.GetFilename(args);
            var input = await InputHelper.ReadStrings(filename);

            var bagtypes = new Dictionary<string, List<(string, int)>>();

            foreach (var bagString in input.Select(s => s.Replace("bags", "bag").Replace("bag", "").Replace(".", "")))
            {
                var bag = ParseBag(bagString);
                bagtypes.Add(bag.Item1, bag.Item2);
            }

            var expandedBagTypes = new Dictionary<string, HashSet<string>>();

            foreach(var bag in bagtypes)
            {
                var visitedBags = new List<string>();
                var toVisit = new Queue<string>(bag.Value.Select(bagtype => bagtype.Item1));
                var expanded = new HashSet<string>();
                var bagCount = 0;

                while(toVisit.Count != 0)
                {
                    var bagtype = toVisit.Dequeue();
                    visitedBags.Add(bagtype);
                    if (!expanded.Contains(bagtype))
                    {
                        expanded.Add(bagtype);
                        bagCount++;
                    }

                    if(expandedBagTypes.ContainsKey(bagtype))
                    {
                        expanded.UnionWith(expandedBagTypes[bagtype]);                        
                        continue;
                    }

                    var found = bagtypes[bagtype].Select(inf => inf.Item1);
                    expanded.UnionWith(found);

                    foreach(var foundBagtype in found)
                    {
                        if(!toVisit.Contains(foundBagtype) && !visitedBags.Contains(foundBagtype))
                        {
                            toVisit.Enqueue(foundBagtype);
                        }
                    }
                }

                expandedBagTypes.Add(bag.Key, expanded);
            }

            var count = expandedBagTypes.Count(i => i.Value.Contains("shiny gold"));
            Console.WriteLine($"Res 1: {count}");                        

            count = visitBag(("shiny gold", 1), bagtypes);
            Console.WriteLine($"Res 2: {count - 1}");
        }

        private static int visitBag(ValueTuple<string, int> bag, Dictionary<string, List<(string, int)>> bagtypes)
        {
            var c = 1;
            foreach(var b in bagtypes[bag.Item1])
            {
                c += b.Item2 * visitBag(b, bagtypes);
            }

            return c;
        }

        private static (string, List<(string, int)>) ParseBag(string input)
        {
            var parts = input.Split("contain");
            var bagName = parts[0].Trim();
            var canContain = new List<(string, int)>();
            var containParts = parts[1].Replace(".", "").Split(",");

            foreach (var desc in containParts.Select(part => part.Trim()))
            {
                if (desc != "no other")
                {
                    var num = int.Parse(desc.Substring(0, 1));
                    canContain.Add((desc.Substring(2), num));
                }
            }

            return (bagName, canContain);
        }
    }
}
