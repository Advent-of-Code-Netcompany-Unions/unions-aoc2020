using AoCLib;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace _11._December
{
    class December11Solver : ChallengeSolver
    {
        private Grid2D<char> CurrentGrid;

        public override async Task Solve(string filename)
        {
            var input = await InputHelper.GetTwoDimensionalArray(filename);

            CurrentGrid = new Grid2D<char>(input);                        
            while (TryUpdate(GetUpdatedValue1))
            {
               //CurrentGrid.Print();
            }                                  

            Console.WriteLine($"Res1: {CurrentGrid.Count('#')}");

            CurrentGrid = new Grid2D<char>(input);
            while (TryUpdate(GetUpdatedValue2))
            {
                //CurrentGrid.Print();
            }

            Console.WriteLine($"Res2: {CurrentGrid.Count('#')}");
        }

        private bool TryUpdate(Func<int, int, char> updateStrategy)
        {
            var updGrid = new Grid2D<char>(CurrentGrid.Width, CurrentGrid.Height);
            var hasChanges = false;
            for (var y = 0; y < CurrentGrid.Height; y++)
            {
                for (var x = 0; x < CurrentGrid.Width; x++)
                {
                    updGrid.Contents[x, y] = updateStrategy(x, y);
                    hasChanges |= CurrentGrid.Contents[x, y] != updGrid.Contents[x, y];

                }
            }            
            CurrentGrid = updGrid;
            return hasChanges;
        }

        private char GetUpdatedValue1(int x, int y)
        {
            var currentVal = CurrentGrid.Contents[x, y];
            if (currentVal == '.')
            {
                return '.';
            }

            var occSeats = CountNearbyOccupiedSeats(x, y);
            if (currentVal == 'L')
            {
                return occSeats == 0 ? '#' : 'L';
            }
            if (currentVal == '#')
            {                
                return occSeats >= 4 ? 'L' : '#';
            }
            throw new Exception("Illegal map value: " + currentVal);
        }

        private char GetUpdatedValue2(int x, int y)
        {
            var currentVal = CurrentGrid.Contents[x, y];
            if(currentVal == '.')
            {
                return '.';
            }

            var occSeats = CountVisibleOccupiedSeats(x, y);
            if(currentVal == 'L')
            {
                return occSeats == 0 ? '#' : 'L';
            }
            if(currentVal == '#')
            {
                return occSeats >= 5 ? 'L' : '#';
            }
            throw new Exception("Illegal map value: " + currentVal);
        }

        private int CountNearbyOccupiedSeats(long x, long y)
        {
            var nearbySeatCoordinates = DirectionUtils.DirectionVectors.Values.Select(v => (X: x + v.DeltaX, Y: y + v.DeltaY));
            var validSeats = nearbySeatCoordinates.Where(CurrentGrid.IsValidCoordinate);            
            var seatVals = validSeats.Select(pos => CurrentGrid.Contents[pos.X, pos.Y]);

            return seatVals.Count(c => c == '#');
        }

        private int CountVisibleOccupiedSeats(int x, int y)        {

            var visibleSeats = DirectionUtils.DirectionVectors.Values.Select(v => Look((x, y), v));
            return visibleSeats.Count(c => c == '#');
        }

        private char Look((int x, int y) position, (int deltaX, int deltaY) direction)
        {
            var spotted = '.';
            var currentX = position.x + direction.deltaX;
            var currentY = position.y + direction.deltaY;
            while(spotted == '.' && CurrentGrid.IsValidCoordinate((currentX, currentY)))
            {
                spotted = CurrentGrid.Contents[currentX, currentY];
                currentX += direction.deltaX;
                currentY += direction.deltaY;                
            }

            return spotted;
        }
    }
}
