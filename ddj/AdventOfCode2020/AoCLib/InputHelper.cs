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

        public static async Task<IEnumerable<long>> ReadLongs(string filename)
        {
            return (await ReadStrings(filename)).Select(long.Parse);
        }

        public static async Task<IEnumerable<IEnumerable<string>>> GetStringsGroupedByEmptyLine(string filename)
        {
            var lines = await ReadStrings(filename);
            var current = new List<string>();
            var res = new List<IEnumerable<string>>() { current };            

            foreach (var line in lines)
            {
                if (line == string.Empty)
                {
                    current = new List<string>();
                    res.Add(current);
                    continue;
                }

                current.Add(line);
            }

            return res;
        }

        public static async Task<char[,]> GetTwoDimensionalArray(string filename)
        {
            var lines = (await ReadStrings(filename)).Select(line => line.ToCharArray()).ToArray();
            var height = lines.Length;
            var width = lines.First().Length;
            var res = new char[width, height];

            for(var i = 0; i < height; i++)
            {
                for(var j = 0; j < width; j++)
                {
                    res[j, i] = lines[i][j];
                }
            }

            return res;
        }
    }
}
