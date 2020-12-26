using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _19._December
{
    class December19Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.GetStringsGroupedByEmptyLine(filename)).ToList();

            var rules = input[0];
            var strings = input[1];

            var ruleSet = new RuleSet(rules);
            var validRules = strings.Select(ruleSet.Matches);

            Console.WriteLine($"Res1: {validRules.Count(b => b)}");

            ruleSet.Rules[8] = new Rule("42 | 42 8");
            ruleSet.Rules[11] = new Rule("42 31 | 42 11 31");

            validRules = strings.Select(ruleSet.Matches);

            Console.WriteLine($"Res2: {validRules.Count(b => b)}");
        }

        public override IEnumerable<string> GetInputFiles()
        {
            return new string[] { "example.txt", "input.txt" };
        }
    }
}
