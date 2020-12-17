using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AoCLib
{
    public class Grid3D<T>
    {
        public long Height;
        public long Width;
        public long Depth;
        public T[,,] Contents;

        public Grid3D(T[,,] contents)
        {
            Contents = contents;
            Width = contents.GetLength(0);
            Height = contents.GetLength(1);
            Depth = contents.GetLength(2);
        }

        public Grid3D(long width, long height, long depth)
        {
            Contents = new T[width, height, depth];
            Width = width;
            Height = height;
            Depth = depth;
        }

        public long Count(T val)
        {
            var count = 0;

            for (var z = 0; z < Depth; z++)
            {
                for (var y = 0; y < Height; y++)
                {
                    for (var x = 0; x < Width; x++)
                    {
                        if (Contents[x, y, z].Equals(val))
                        {
                            count++;
                        }
                    }
                }
            }

            return count;
        }

        public void Print()
        {
            for (var z = 0; z < Depth; z++)
            {
                Console.WriteLine($"z: {z}");
                for (var y = 0; y < Height; y++)
                {
                    for (var x = 0; x < Width; x++)
                    {
                        var c = Contents[x, y, z];
                        Console.Write(c + " ");
                    }
                    Console.WriteLine();
                }
                Console.WriteLine();
            }
        }

        public bool IsValidCoordinate(long x, long y, long z)
        {
            return x >= 0 && x < Width && y >= 0 && y < Height && z >= 0 && z < Depth;
        }
    }
}
