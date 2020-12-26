using System;
using System.Collections.Generic;
using System.Linq;

class Rule
{
    private readonly string StringMatch;
    private readonly List<List<int>> RuleMatches;

    public Rule(string rawRuleContent)
    {       
        if (rawRuleContent.StartsWith('\"'))
        {
            StringMatch = rawRuleContent.Replace("\"", "");            
            return;
        }

        RuleMatches = new List<List<int>>();
        var rulesToMatch = rawRuleContent.Split('|');
        foreach (var ruleToMatch in rulesToMatch)
        {
            var ruleKeys = ruleToMatch.Trim().Split(' ').Select(int.Parse);
            RuleMatches.Add(ruleKeys.ToList());
        }
    }

    public IEnumerable<string> Match(string s, Dictionary<int, Rule> otherRules)
    {
        if (StringMatch != null)
        {
            //"aa".StartsWith("a") -> false if you're running on a danish system. ooof.
            if(s.StartsWith(StringMatch, StringComparison.Ordinal))
            {
                yield return s[1..];
            }            
            yield break;
        }

        foreach (var setToMatch in RuleMatches)
        {
            IEnumerable<string> remaining = new List<string>() { s };
            foreach (var rule in setToMatch)
            {
                var remainsAfterRule = new List<string>();
                foreach (var remainder in remaining)
                {
                    remainsAfterRule.AddRange(otherRules[rule].Match(remainder, otherRules));
                }
                remaining = remainsAfterRule;
            }

            foreach (var match in remaining)
            {
                yield return match;
            }
        }
    }
}