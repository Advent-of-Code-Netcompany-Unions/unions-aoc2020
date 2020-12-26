using System.Collections.Generic;
using System.Linq;

namespace _21._December
{
    public class Declaration
    {
        public List<string> Ingredients { get; init; }
        public List<string> Allergens { get; init; }

        public Declaration(string rawInput)
        {
            var parts = rawInput.Split(" (contains ");
            Ingredients = parts[0].Split(" ").ToList();
            Allergens = parts[1].Replace(")", "").Split(", ").ToList();
        }
    }
}
