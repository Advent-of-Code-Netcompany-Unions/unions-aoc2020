using System.Collections.Generic;
using System.Linq;

namespace _1._December
{
    public class December1Solver
    {
        private List<int?> sortedInputs { get; init; }
        private int targetSum { get; init; }
        private int targetSetSize { get; init; }

        public December1Solver(IEnumerable<int> inputs, int targetSum, int targetSetSize)
        {
            this.targetSum = targetSum;
            this.targetSetSize = targetSetSize;
            sortedInputs = inputs.OrderBy(n => n).Select(n => (int?)n).ToList();
        }

        public int? Solve()
        {
            return SolveRecursively(0, 0, 0);
        }

        private int? SolveRecursively(int currentSum, int currentSetSize, int startIndex)
        {
            //Only one number missing
            if(currentSetSize + 1 == targetSetSize)
            {                
                var candidate = sortedInputs
                    .Skip(startIndex)
                    .SkipWhile(n => n + currentSum < targetSum)
                    .FirstOrDefault();

                return candidate + currentSum == targetSum ? candidate : null;
            }
            else
            {
                while(startIndex < sortedInputs.Count)
                {
                    var candidate = sortedInputs[startIndex];
                    var newSum = currentSum + candidate.Value;

                    if(newSum >= targetSum)
                    {
                        //Sum is guaranteed to be increasing due to sorting, abort early
                        return null;
                    }

                    var potentialRes = SolveRecursively(newSum, currentSetSize + 1, startIndex + 1);
                    
                    if(potentialRes.HasValue)
                    {
                        return potentialRes * candidate;
                    }

                    startIndex++;
                }                
            }

            return null;
        }
    }
}
