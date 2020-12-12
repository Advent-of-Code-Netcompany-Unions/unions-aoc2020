using AoCLib;
using System;
using System.Collections.Generic;

namespace _12._December
{
    class Ferry
    {
        public Dictionary<long, Grid2D<int>.Direction> DirectionDegreeMap = new Dictionary<long, Grid2D<int>.Direction> {
            { 0, Grid2D<int>.Direction.EAST },
            { 90, Grid2D<int>.Direction.SOUTH },
            { 180, Grid2D<int>.Direction.WEST },
            { 270, Grid2D<int>.Direction.NORTH },
            {-270, Grid2D<int>.Direction.SOUTH },
            {-180, Grid2D<int>.Direction.WEST },
            {-90, Grid2D<int>.Direction.NORTH },
        };        

        public (long x, long y) Position { get; set; } = (0, 0);
        public int Facing { get; set; } = 0;

        public (long x, long y) Waypoint { get; set; } = (10, -1);

        public void Turn(int degrees)
        {
            if(degrees % 90 != 0)
            {
                throw new Exception("Unexpected turn angle.");
            }

            var newDirection = (Facing + degrees) % 360;
            Facing = newDirection;
        }

        public void Move(Grid2D<int>.Direction direction, int distance)
        {
            var directionVector = Grid2D<int>.DirectionVectors[direction];
            var deltaX = directionVector.deltaX * distance;
            var deltaY = directionVector.deltaY * distance;

            Position = (Position.x + deltaX, Position.y + deltaY);
        }

        public void MoveWaypoint(Grid2D<int>.Direction direction, int distance)
        {
            var directionVector = Grid2D<int>.DirectionVectors[direction];
            var deltaX = directionVector.deltaX * distance;
            var deltaY = directionVector.deltaY * distance;

            Waypoint = (Waypoint.x + deltaX, Waypoint.y + deltaY);
        }

        public void MoveForward(int distance)
        {
            Move(DirectionDegreeMap[Facing], distance);
        }

        public void MoveToWaypoint(int times)
        {
            var deltaX = Waypoint.x * times;
            var deltaY = Waypoint.y * times;

            Position = (Position.x + deltaX, Position.y + deltaY);
        }

        public void RotateWaypoint(int degrees)
        {
            if (degrees % 90 != 0)
            {
                throw new Exception("Unexpected rotation angle.");
            }

            var rotNum = (degrees % 360) / 90;
            if (rotNum < 0)
            {
                TransformWaypointLeft(Math.Abs(rotNum));
            }
            else
            {
                TransformWaypointRight(rotNum);
            }
        }

        private void TransformWaypointLeft(int n)
        {
            for(var i = 0; i < n; i++)
            {
                Waypoint = (Waypoint.y, -Waypoint.x);
            }
        }

        private void TransformWaypointRight(int n)
        {
            for (var i = 0; i < n; i++)
            {
                Waypoint = (-Waypoint.y, Waypoint.x);
            }
        }
    }
}
