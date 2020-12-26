using AoCLib;
using AoCLib.DAG;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _7._December
{
    class December7Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadStrings(filename);

            var processedInput = PreprocessInput(input);
            var graph = BuildGraph(processedInput);

            //A node is connected to itself, so exclude shiny gold itself from the count
            var res1 = graph.Nodes.Where(n => n.IsConnectedTo("shiny gold")).Count() - 1;
            Console.WriteLine($"Res 1: {res1}");

            //Brute-force approach to computing the smallest bags first
            while (graph.Nodes.Any(n => n.Value == null))
            {
                graph.Nodes.First(n => !n.Value.HasValue && n.CanComputeNumBags()).ComputeNumBags();
            }

            //The value of a node is the total number of bags including itself, but again we don't want to count the bag.
            var res2 = graph.Nodes.First(n => n.Name == "shiny gold").Value - 1;
            Console.WriteLine($"Res 2: {res2}");
        }

        private IEnumerable<string> PreprocessInput(IEnumerable<string> input)
        {
            //Remove "bags", "bag" and "." from input since they carry no relevant info
            return input.Select(s => s.Replace("bags", "bag").Replace("bag", "").Replace(".", ""));
        }

        private DirectedAcyclicGraph<BagNode, long?> BuildGraph(IEnumerable<string> input)
        {
            var bags = input.Select(ParseBag).ToDictionary(b => b.Type);
            var bagNodes = bags.Select(bag => new BagNode(bag.Value.Type)).ToDictionary(b => b.Name);
            foreach (var node in bagNodes.Values)
            {
                var bagsInside = bags[node.Name].BagsInside;
                node.Connections.UnionWith(bagsInside.Select(b => new GraphEdge<long?> { From = node, To = bagNodes[b.Type], Cost = b.Count }));
            }

            return new DirectedAcyclicGraph<BagNode, long?>(bagNodes.Values);
        }

        private (string Type, List<(string Type, int Count)> BagsInside) ParseBag(string input)
        {
            var parts = input.Split("contain");
            var bagName = parts[0].Trim();
            var canContain = new List<(string, int)>();
            var containParts = parts[1].Split(",").Select(s => s.Trim());

            foreach (var desc in containParts)
            {
                if (desc != "no other")
                {
                    var num = int.Parse(desc.Substring(0, 1));
                    canContain.Add((desc[2..], num));
                }
            }

            return (bagName, canContain);
        }
    }
}
