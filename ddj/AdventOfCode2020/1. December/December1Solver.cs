using System.Collections.Generic;
using System.Linq;

namespace _1._December
{
    public class December1Solver
    {
        private List<long?> SortedInputs { get; init; }
        private long TargetSum { get; init; }
        private int TargetSetSize { get; init; }

        public December1Solver(IEnumerable<long> inputs, long targetSum, int targetSetSize)
        {
            this.TargetSum = targetSum;
            this.TargetSetSize = targetSetSize;
            SortedInputs = inputs.OrderBy(n => n).Select(n => (long?)n).ToList();
        }

        public long? Solve()
        {
            return SolveRecursively(0, 0, 0);
        }

        private long? SolveRecursively(long currentSum, int currentSetSize, int startIndex)
        {
            //Only one number missing
            if(currentSetSize + 1 == TargetSetSize)
            {                
                var candidate = SortedInputs
                    .Skip(startIndex)
                    .SkipWhile(n => n + currentSum < TargetSum)
                    .FirstOrDefault();

                return candidate + currentSum == TargetSum ? candidate : null;
            }
            else
            {
                while(startIndex < SortedInputs.Count)
                {
                    var candidate = SortedInputs[startIndex];
                    var newSum = currentSum + candidate.Value;

                    if(newSum >= TargetSum)
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
