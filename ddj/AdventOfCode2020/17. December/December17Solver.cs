using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace _17._December
{
    class December17Solver : ChallengeSolver
    {
        private GridND<char> CurrentGrid;

        public override async Task Solve(string filename)
        {
            var input = await InputHelper.GetThreeDimensionalArray(filename);
            CurrentGrid = new GridND<char>(input);            

            for(var i = 0; i < 6; i++)
            {                
                TryUpdate();
            }

            Console.WriteLine($"Res1: {CurrentGrid.Count('#')}");

            var inputAs4d = await InputHelper.GetFourDimensionalArray(filename);
            CurrentGrid = new GridND<char>(inputAs4d);

            for (var i = 0; i < 6; i++)
            {
                TryUpdate();
            }

            Console.WriteLine($"Res2: {CurrentGrid.Count('#')}");
        }

        private void TryUpdate()
        {
            var updGrid = new GridND<char>(CurrentGrid.Dimensions.Select(n => n + 2).ToArray());

            var counters = new long[updGrid.Dimensions.Length];
            var lastCounter = counters.Length - 1;
            while(counters[lastCounter] < updGrid.Dimensions[lastCounter])
            {
                var val = IsActiveNextRound(counters.Select(n => n - 1).ToArray()) ? '#' : '.';
                updGrid.Contents.SetValue(val, counters);

                var currentCounter = 0;
                counters[currentCounter]++;
                while (counters[currentCounter] >= updGrid.Dimensions[currentCounter] && currentCounter < counters.Length - 1)
                {                    
                    counters[currentCounter] = 0;
                    
                    currentCounter++;
                    counters[currentCounter]++;
                }                
            }

            CurrentGrid = updGrid;            
        }

        private bool IsActiveNextRound(long[] baseCoordinate)
        {
            var activeNeighbourCount = 0;
            var neighbours = GetCoordinatesWithinRange(baseCoordinate, -1, 1).ToList();
            foreach (var coord in neighbours)
            {
                if (coord.SequenceEqual(baseCoordinate))
                {
                    continue;
                }

                if (CurrentGrid.IsValidCoordinate(coord))
                {
                    if (CurrentGrid.Get(coord) == '#')
                    {
                        activeNeighbourCount += 1;
                    }
                }            
            }

            if(CurrentGrid.IsValidCoordinate(baseCoordinate) && CurrentGrid.Get(baseCoordinate) == '#')
            {
                return activeNeighbourCount == 2 || activeNeighbourCount == 3;
            }

            return activeNeighbourCount == 3;
        }

        private IEnumerable<long[]> GetCoordinatesWithinRange(long[] coord, int lowerBound, int upperBound)
        {
            var res = new List<long[]>();

            if (coord.Length > 0)
            {
                for (var i = lowerBound; i <= upperBound; i++)
                {                  

                    var subResults = GetCoordinatesWithinRange(coord.Skip(1).ToArray(), lowerBound, upperBound);
                    if(subResults.Any())
                    {
                        foreach(var subResult in subResults)
                        {
                            var tempres = new long[coord.Length];
                            tempres[0] = coord[0] + i;
                            subResult.ToArray().CopyTo(tempres, 1);
                            res.Add(tempres);
                        }
                    }
                    else
                    {
                        var tempres = new long[] { coord[0] + i };                        
                        res.Add(tempres);
                    }
                }
            }

            return res;
        }
    }
}
