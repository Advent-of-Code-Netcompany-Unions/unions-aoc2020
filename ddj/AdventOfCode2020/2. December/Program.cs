using AoCLib;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace _2._December
{
    class Program
    {
        static async Task Main(string[] args)
        {
            var filename = InputHelper.GetFilename(args);
            var inputs = await InputHelper.ReadStrings(filename);

            var passwordInfos = inputs.Select(s => new PasswordInfo(s));
            var validPasswords = passwordInfos.Select(passwordInfo => ValidatePasswordInfo(passwordInfo));
            var validPasswords2 = passwordInfos.Select(passwordInfo => ValidatePasswordInfoV2(passwordInfo));

            Console.WriteLine($"Valid passwords (Version 1): {validPasswords.Where(b => b).Count()}. (Also, these elfs should really hash and salt their passwords...)");

            Console.WriteLine($"Valid passwords (Version 2): {validPasswords2.Where(b => b).Count()}. (Also, these elfs should really hash and salt their passwords...)");
        }

        private static bool ValidatePasswordInfo(PasswordInfo info)
        {
            var occurences = info.Password.Where(c => c == info.Policy.RelevantChar);

            return occurences.Count() >= info.Policy.FirstNumber
                && occurences.Count() <= info.Policy.SecondNumber; 
        }

        private static bool ValidatePasswordInfoV2(PasswordInfo info)
        {
            return info.Password[info.Policy.FirstNumber - 1] == info.Policy.RelevantChar
                ^ info.Password[info.Policy.SecondNumber - 1] == info.Policy.RelevantChar;
        }
    }
}
