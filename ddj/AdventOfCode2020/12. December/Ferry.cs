using AoCLib;
using System;
using System.Collections.Generic;

namespace _12._December
{
    class Ferry
    {
        public Dictionary<long, Direction> DirectionDegreeMap = new Dictionary<long, Direction> {
            { 0, Direction.EAST },
            { 90, Direction.SOUTH },
            { 180, Direction.WEST },
            { 270, Direction.NORTH },
            {-270, Direction.SOUTH },
            {-180, Direction.WEST },
            {-90, Direction.NORTH },
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

        public void Move(Direction direction, int distance)
        {
            var directionVector = DirectionUtils.DirectionVectors[direction];
            var deltaX = directionVector.DeltaX * distance;
            var deltaY = directionVector.DeltaY * distance;

            Position = (Position.x + deltaX, Position.y + deltaY);
        }

        public void MoveWaypoint(Direction direction, int distance)
        {
            var directionVector = DirectionUtils.DirectionVectors[direction];
            var deltaX = directionVector.DeltaX * distance;
            var deltaY = directionVector.DeltaY * distance;

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
