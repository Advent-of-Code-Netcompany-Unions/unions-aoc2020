using System.Collections.Generic;

namespace AoCLib
{
    public enum CardinalDirection { NORTH, EAST, SOUTH, WEST }
    public enum Direction { NORTH, NORTH_EAST, EAST, SOUTH_EAST, SOUTH, SOUTH_WEST, WEST, NORTH_WEST }       

    public class DirectionUtils
    {
        public static readonly Dictionary<CardinalDirection, (int DeltaX, int DeltaY)> CardinalDirectionVectors = new Dictionary<CardinalDirection, (int, int)> {
            { CardinalDirection.NORTH, (0, -1) },
            { CardinalDirection.EAST, (1, 0) },
            { CardinalDirection.SOUTH, (0, 1) },
            { CardinalDirection.WEST, (-1, 0) },
        };

        public static readonly Dictionary<Direction, (int DeltaX, int DeltaY)> DirectionVectors = new Dictionary<Direction, (int, int)> {
            { Direction.NORTH, (0, -1) },
            { Direction.NORTH_EAST, (1, -1) },
            { Direction.EAST, (1, 0) },
            { Direction.SOUTH_EAST, (1, 1) },
            { Direction.SOUTH, (0, 1) },
            { Direction.SOUTH_WEST, (-1, 1) },
            { Direction.WEST, (-1, 0) },
            { Direction.NORTH_WEST, (-1, -1) }
        };

        public static CardinalDirection RotateClockwise(CardinalDirection direction)
        {
            var val = (int) direction;
            return (CardinalDirection)(++val % 4);
        }

        public static CardinalDirection RotateClockwise(CardinalDirection direction, int numRotations)
        {
            var dir = direction;
            for (var i = 0; i < numRotations; i++)
            {
                dir = RotateClockwise(dir);
            }
            return dir;
        }

        public static Direction RotateClockwise(Direction direction)
        {
            var val = (int)direction;
            return (Direction)(++val % 8);
        }

        public static Direction RotateClockwise(Direction direction, int numRotations)
        {
            var dir = direction;
            for (var i = 0; i < numRotations; i++)
            {
                dir = RotateClockwise(dir);
            }
            return dir;
        }
    }
}
