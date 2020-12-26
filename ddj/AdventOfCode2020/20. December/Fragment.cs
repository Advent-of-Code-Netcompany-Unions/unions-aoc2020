using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;

namespace _20._December
{
    class Fragment
    {
        public int Id { get; init; }

        public char[,] ImageData { get; private set; }
        public long Size { get; private set; }

        public Dictionary<CardinalDirection, char[]> Edges { get; private set; }
        public Dictionary<CardinalDirection, IEnumerable<Fragment>> AdjacencyLists { get; set; } = new Dictionary<CardinalDirection, IEnumerable<Fragment>>();

        public CardinalDirection Orientation { get; set; } = CardinalDirection.NORTH;
        public bool Flipped = false;

        public Fragment(IEnumerable<string> rawData)        {            

            Id = int.Parse(rawData.First().Replace("Tile ", "").Replace(":", ""));
            var imgData = rawData.Skip(1);

            Size = imgData.Count();

            Edges = new Dictionary<CardinalDirection, char[]>
            {
                [CardinalDirection.NORTH] = imgData.First().ToCharArray(),
                [CardinalDirection.SOUTH] = imgData.Last().ToCharArray(),
                [CardinalDirection.WEST] = imgData.Select(s => s.First()).ToArray(),
                [CardinalDirection.EAST] = imgData.Select(s => s.Last()).ToArray()
            };

            ImageData = InputHelper.GetTwoDimensionalArrayFromStringList(imgData.ToList());         
        }

        public Fragment(int id, char[,] data, long size, Dictionary<CardinalDirection, char[]> edges, Dictionary<CardinalDirection, IEnumerable<Fragment>> adjacencies)
        {
            Id = id;
            ImageData = data;
            Size = size;
            Edges = edges;
            AdjacencyLists = adjacencies;
        }

        public void RotateClockwise()
        {
            var newEdges = new Dictionary<CardinalDirection, char[]>();
            var newAdjacencyLists = new Dictionary<CardinalDirection, IEnumerable<Fragment>>();
            foreach(var pair in Edges)
            {
                var newDirection = DirectionUtils.RotateClockwise(pair.Key);
                var (DeltaX, DeltaY) = DirectionUtils.CardinalDirectionVectors[pair.Key];
                var newVector = DirectionUtils.CardinalDirectionVectors[newDirection];
                var reverse = DeltaX + DeltaY == newVector.DeltaX + newVector.DeltaY;
                newEdges[newDirection] = reverse ? pair.Value?.Reverse()?.ToArray() : pair.Value;
                newAdjacencyLists[newDirection] = AdjacencyLists[pair.Key];                
            }

            Edges = newEdges;
            AdjacencyLists = newAdjacencyLists;
            Orientation = DirectionUtils.RotateClockwise(Orientation);
        }

        public void RotateContentsClockwise()
        {
            var newContent = new char[Size, Size];

            for (var y = 0; y < Size; y++)
            {
                for (var x = 0; x < Size; x++)
                {
                    var newX = Size - y - 1;
                    var newY = x;
                    newContent[newX, newY] = ImageData[x, y];
                }
            }

            ImageData = newContent;
        }

        public void FlipContents()
        {
            var newContent = new char[Size, Size];

            for (var y = 0; y < Size; y++)
            {
                for (var x = 0; x < Size; x++)
                {
                    newContent[x, y] = ImageData[x, Size - y - 1];
                }
            }
            ImageData = newContent;
        }

        public void Flip()
        {
            var newEdges = new Dictionary<CardinalDirection, char[]>
            {
                [CardinalDirection.NORTH] = Edges[CardinalDirection.SOUTH],
                [CardinalDirection.SOUTH] = Edges[CardinalDirection.NORTH],
                [CardinalDirection.EAST] = Edges[CardinalDirection.EAST]?.Reverse()?.ToArray(),
                [CardinalDirection.WEST] = Edges[CardinalDirection.WEST]?.Reverse()?.ToArray()
            };
            var newAdjacencies = new Dictionary<CardinalDirection, IEnumerable<Fragment>>
            {
                [CardinalDirection.NORTH] = AdjacencyLists[CardinalDirection.SOUTH],
                [CardinalDirection.SOUTH] = AdjacencyLists[CardinalDirection.NORTH],
                [CardinalDirection.EAST] = AdjacencyLists[CardinalDirection.EAST],
                [CardinalDirection.WEST] = AdjacencyLists[CardinalDirection.WEST]
            };

            Edges = newEdges;
            AdjacencyLists = newAdjacencies;

            Flipped = !Flipped;            
        }

        public Fragment WithoutBorder()
        {           
            var newSize = Size - 2;            

            var newContent = new char[Size, Size];
            for (var y = 1; y < Size; y++)
            {
                for(var x = 1; x < Size; x++)
                {
                    newContent[x - 1, y - 1] = ImageData[x, y];
                }
            }            

            var frag = new Fragment(Id, newContent, newSize, null, AdjacencyLists);
            if(Flipped)
            {
                frag.FlipContents();
            }

            for(var i = 0; i < (int) Orientation; i++)
            {
                frag.RotateContentsClockwise();
            }

            return frag;
        }

        public override string ToString()
        {
            return $"{Id}: {Orientation} {(Flipped ? "Flipped" : "")}";
        }
    }
}
