using System.Collections.Generic;
using System.Linq;

namespace _3._December
{
    class Map
    {
        private int Height;
        private int Width;
        private char[][] data;
        public Map(IEnumerable<string> input)
        {
            Height = input.Count();
            Width = input.FirstOrDefault().Count();
            data = input.Select(s => s.ToCharArray()).ToArray();
        }

        public bool SquareHasTree(int x, int y)
        {
            return data[y][x % Width] == '#';
        }

        public int TreesOnSlope((int deltaX, int deltaY) slope)
        {
            var count = 0;
            var index = (x: 0, y: 0);
            while (index.y < Height)
            {
                if (SquareHasTree(index.x, index.y))
                {
                    count++;
                }

                index = (index.x + slope.deltaX, index.y + slope.deltaY);
            }

            return count;
        }
    }
}
