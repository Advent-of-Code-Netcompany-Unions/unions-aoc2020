using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _4._December
{
    class December4Solver : ChallengeSolver
    {
        private static readonly string[] reqProperties = { "byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid" };
        public override async Task Solve(string filename)
        {
            var inputGroups = await InputHelper.GetStringsGroupedByEmptyLine(filename);

            var credentials = new List<Dictionary<string, string>>();

            foreach (var group in inputGroups)
            {
                var current = new Dictionary<string, string>();

                foreach (var line in group)
                {
                    var pairs = line.Split(" ");
                    foreach (var p in pairs)
                    {
                        var data = p.Split(":");
                        current.Add(data[0], data[1]);
                    }
                }

                credentials.Add(current);
            }

            var fullCredentials = credentials.Where(c => reqProperties.All(p => c.Keys.Contains(p)));
            Console.WriteLine($"Result 1: {fullCredentials.Count()}");

            var validCrendetials = fullCredentials.Where(c => c.All(prop => ValidateProperty(prop.Key, prop.Value)));
            Console.WriteLine($"Result 2: {validCrendetials.Count()}");
        }

        private bool ValidateProperty(string key, string value)
        {
            switch (key)
            {
                case "byr":
                    var byr = int.Parse(value);
                    return byr >= 1920 && byr <= 2002;
                case "iyr":
                    var iyr = int.Parse(value);
                    return iyr >= 2010 && iyr <= 2020;
                case "eyr":
                    var eyr = int.Parse(value);
                    return eyr >= 2020 && eyr <= 2030;
                case "hgt":
                    if (value.EndsWith("cm"))
                    {
                        var couldParse = int.TryParse(value.Substring(0, 3), out var cm);
                        return couldParse && cm >= 150 && cm <= 193;
                    }
                    else if (value.EndsWith("in"))
                    {
                        var couldParse = int.TryParse(value.Substring(0, 2), out var inc);
                        return couldParse && inc >= 59 && inc <= 76;
                    }
                    return false;
                case "hcl":
                    return value.FirstOrDefault() == '#' && value.Skip(1).All(c => char.IsLetterOrDigit(c));
                case "ecl":
                    return value == "amb" || value == "blu" || value == "brn" || value == "gry" || value == "grn" || value == "hzl" || value == "oth";
                case "pid":
                    return value.Length == 9 && value.All(char.IsDigit);
                case "cid":
                    return true;
                default:
                    return false;
            }
        }
    }
}
