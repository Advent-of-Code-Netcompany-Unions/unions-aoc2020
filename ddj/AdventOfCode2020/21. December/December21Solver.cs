using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _21._December
{
    class December21Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadStrings(filename);

            var declarations = input.Select(s => new Declaration(s));

            var allergenPotential = new Dictionary<string, HashSet<string>>();
            var allIngredients = new List<string>();

            foreach (var dec in declarations)
            {
                allIngredients.AddRange(dec.Ingredients);

                foreach (var allergen in dec.Allergens)
                {
                    if (allergenPotential.ContainsKey(allergen))
                    {
                        allergenPotential[allergen] = allergenPotential[allergen].Intersect(dec.Ingredients).ToHashSet();
                    }
                    else
                    {
                        allergenPotential[allergen] = dec.Ingredients.ToHashSet();
                    }
                }
            }

            var unsafeIngredients = new HashSet<string>();
            foreach(var ing in allergenPotential.Values)
            {
                unsafeIngredients = unsafeIngredients.Union(ing).ToHashSet();
            }

            var safeIngredients = allIngredients.ToHashSet().Except(unsafeIngredients);

            var res1 = allIngredients.Count(ing => safeIngredients.Contains(ing));
            Console.WriteLine($"Res1: {res1}");

            var canonicalAllergenDict = RefineAllergenDict(allergenPotential);
            var res2 = canonicalAllergenDict.OrderBy(pair => pair.Key).Aggregate("", (s, val) => s + "," + val.Value)[1..];

            Console.WriteLine($"Res2: {res2}");
        }

        private Dictionary<string, string> RefineAllergenDict(Dictionary<string, HashSet<string>> potentialAllergens)
        {
            var res = new Dictionary<string, string>();

            while(potentialAllergens.Any())
            {
                var next = potentialAllergens.FirstOrDefault(pair => pair.Value.Count == 1);
                var ingredient = next.Value.First();
                res.Add(next.Key, ingredient);
                RemoveIngredientFromDict(ingredient, potentialAllergens);
            }

            return res;
        }

        private void RemoveIngredientFromDict(string ingredient, Dictionary<string, HashSet<string>> potentialAllergens)
        {
            foreach(var pair in potentialAllergens)
            {
                var set = potentialAllergens[pair.Key];
                set.Remove(ingredient);
                if(set.Count == 0)
                {
                    potentialAllergens.Remove(pair.Key);
                }                
            }
        }
    }
}
