using System;
using System.Linq;

namespace _2._December
{
    public class PasswordPolicy
    {
        public int FirstNumber { get; init; }
        public int SecondNumber { get; init; }
        public char RelevantChar { get; init; }
        public PasswordPolicy(string policyString)
        {
            var policyParts = policyString.Split(" ");
            RelevantChar = policyParts.Last().First();
            var occurrenceSpec = policyParts.First().Split("-");
            FirstNumber = int.Parse(occurrenceSpec.First());
            SecondNumber = int.Parse(occurrenceSpec.Last());
        }
    }
}
