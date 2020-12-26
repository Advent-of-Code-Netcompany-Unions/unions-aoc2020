using System.Collections.Generic;
using System.Linq;

namespace _19._December
{
    class RuleSet
    {
        public Dictionary<int, Rule> Rules;        

        public RuleSet(IEnumerable<string> rawRules)
        {
            Rules = rawRules
                .Select(r => r.Split(':').Select(s => s.Trim()).ToList())
                .Select(r => (int.Parse(r[0]), new Rule(r[1])))
                .ToDictionary(pair => pair.Item1, pair => pair.Item2);
        }

        public bool Matches(string s)
        {
            var res = Rules[0].Match(s, Rules);
            return res.Any(s => s == string.Empty);
        }
    }    
}
