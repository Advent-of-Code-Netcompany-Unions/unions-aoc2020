using System.Linq;


namespace _2._December
{
    public class PasswordInfo
    {
        public PasswordPolicy Policy { get; init; }
        public string Password { get; init; }

        public PasswordInfo(string passwordInfoString)
        {
            var parts = passwordInfoString.Split(":").Select(s => s.Trim());
            Policy = new PasswordPolicy(parts.First());
            Password = parts.Last();
        }
    }
}
