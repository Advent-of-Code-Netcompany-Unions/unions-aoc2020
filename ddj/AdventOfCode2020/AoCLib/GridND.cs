using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AoCLib
{
    public class GridND<T>
    {
        public Array Contents;
        public long[] Dimensions;

        public GridND(Array contents)
        {
            Contents = contents;
            Dimensions = new long[contents.Rank];
            for(var i = 0; i < contents.Rank; i++)
            {
                Dimensions[i] = contents.GetLength(i);
            }
        }

        public GridND(long[] dimensions)
        {
            Contents = Array.CreateInstance(typeof(T), dimensions);
            Dimensions = dimensions;            
        }

        public T Get(long[] coord)
        {
            if(IsValidCoordinate(coord))
            {
                return (T)Contents.GetValue(coord);
            }

            throw new IndexOutOfRangeException($"{coord}");
        }

        public long Count(T val)
        {
            var count = 0;

            var enumerator = Contents.GetEnumerator();            
            while(enumerator.MoveNext())
            {
                if(((T) enumerator.Current).Equals(val))
                {
                    count++;
                }
            }

            return count;
        }

        public bool IsValidCoordinate(long[] coord)
        {
            if(coord.Length != Dimensions.Length)
            {
                return false;
            }

            for(var i = 0; i < coord.Length; i++)
            {
                if(coord[i] >= Dimensions[i] || coord[i] < 0)
                {
                    return false;
                }
            }

            return true;
        }
    }
}
