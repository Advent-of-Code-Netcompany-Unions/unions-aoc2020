using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace AoCLib
{
    public static class InputHelper
    {
        private const string defaultFilename = "input.txt";

        public static string GetFilename(string[] args)
        {
            var argFileName = args.FirstOrDefault(args => args.StartsWith("filename="));
            return argFileName?.Replace("filename", "") ?? defaultFilename;
        }

        public static async Task<IEnumerable<string>> ReadStrings(string filename)
        {        
            return await File.ReadAllLinesAsync(filename);
        }

        public static async Task<IEnumerable<int>> ReadInts(string filename)
        {
            return (await ReadStrings(filename)).Select(int.Parse);
        }


    }
}
