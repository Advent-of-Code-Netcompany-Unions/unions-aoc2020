using System;

namespace AoCLib
{
    public class Grid2D<T>
    {       
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

        public Grid2D<T> Copy()
        {
            var theCopy = new Grid2D<T>(Width, Height);
            for(var y = 0; y < Height; y++)
            {
                for(var x = 0; x < Width; x++)
                {
                    theCopy.Contents[x, y] = Contents[x, y];
                }
            }
            return theCopy;
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

        public bool IsValidCoordinate((long x, long y) coordinate)
        {
            return coordinate.x >= 0 && coordinate.x < Width && coordinate.y >= 0 && coordinate.y < Height;
        }
    }
}
