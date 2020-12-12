using System;
using System.Collections.Generic;

namespace AoCLib
{
    public class Grid2D<T>
    {
        public enum Direction { NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST}
        public static readonly Dictionary<Direction, (int deltaX, int deltaY)> DirectionVectors = new Dictionary<Direction, (int, int)> {
            { Direction.NORTH, (0, -1) },
            { Direction.NORTH_EAST, (1, -1) },
            { Direction.EAST, (1, 0) },
            { Direction.SOUTH_EAST, (1, 1) },
            { Direction.SOUTH, (0, 1) },
            { Direction.SOUTH_WEST, (-1, 1) },
            { Direction.WEST, (-1, 0) },
            { Direction.NORTH_WEST, (-1, -1) }
        };

        public T[,] Contents { get; init; }
        public long Width { get; init; }
        public long Height { get; init; }

        public Grid2D(T[,] contents)
        {
            Contents = contents;
            Width = contents.GetLength(0);
            Height = contents.GetLength(1);
        }

        public Grid2D(long width, long height)
        {
            Contents = new T[width, height];
            Width = width;
            Height = height;
        }

        public void Print()
        {
            for (var y = 0; y < Height; y++)
            {
                for (var x = 0; x < Width; x++)
                {
                    var c = Contents[x, y];
                    Console.Write(c + " ");
                }
                Console.WriteLine();
            }
            Console.WriteLine();
        }
        
        public long Count(T val)
        {
            var count = 0;

            for(var y = 0; y < Height; y++)
            {
                for(var x = 0; x < Width; x++)
                {
                    if(Contents[x, y].Equals(val))
                    {
                        count++;
                    }
                }
            }

            return count;
        }

        public bool IsValidCoordinate((int x, int y) coordinate)
        {
            return coordinate.x >= 0 && coordinate.x < Width && coordinate.y >= 0 && coordinate.y < Height;
        }
    }
}
