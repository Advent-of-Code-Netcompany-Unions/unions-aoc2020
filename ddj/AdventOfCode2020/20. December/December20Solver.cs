using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _20._December
{
    class December20Solver : ChallengeSolver
    {
        private static readonly (int DeltaX, int DeltaY)[] SeaMonster = { (0, 0), (1, -1), (3, 0), (1, 1), (1, 0), (1, -1), (3, 0), (1, 1), (1, 0), (1, -1), (3, 0), (1, 1), (1, 1), (0, -1), (1, 0) };

        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.GetStringsGroupedByEmptyLine(filename));

            var fragments = input.Select(s => new Fragment(s)).ToList();

            foreach(var fragment in fragments)
            {
                foreach(var direction in DirectionUtils.CardinalDirectionVectors.Keys)
                {
                    fragment.AdjacencyLists.Add(direction, GetAdjacencyList(fragment.Edges[direction], fragments.Where(f=> f.Id != fragment.Id)));
                }
            }

            var allEdges = fragments.SelectMany(f => f.Edges.Values).ToList();
            allEdges.AddRange(fragments.SelectMany(f => f.Edges.Values.Select(edge => edge.Reverse().ToArray())));

            var corners = fragments.Where(f => GetMatchedEdges(f, allEdges).Count() == 2);

            var res1 = 1L;
            foreach(var c in corners)
            {
                res1 *= c.Id;
            }

            Console.WriteLine($"Res1: {res1}");

            //Uuugh, I actualy have to *do* the puzzle

            var borderPieces = fragments.Where(f => GetMatchedEdges(f, allEdges).Count() == 3);
            var internalPieces = fragments.Where(f => GetMatchedEdges(f, allEdges).Count() == 4);

            //Clean unneeded edges
            var cleanedCorners = corners.Select(f => ClearUnmatchedEdges(f, allEdges));
            var cleanedBorders = borderPieces.Select(f => ClearUnmatchedEdges(f, allEdges));

            var boardSize = borderPieces.Count() / 4 + 2;
            var board = new Grid2D<Fragment>(boardSize, boardSize);

            var solvedBoards = DoPuzzle(board, cleanedCorners, cleanedBorders, internalPieces);                       

            foreach(var solvedBoard in solvedBoards)
            {
                DropAllBorders(solvedBoard);
                var image = MergeBoard(solvedBoard);
                var monsters = CountMonsters(image);
                var stormyTiles = image.Count('#');
                if(monsters > 0)
                {
                    Console.WriteLine($"Image contains {stormyTiles} stormy tiles and {monsters} sea monsters. Solution is {stormyTiles - monsters * SeaMonster.Length}");
                    return;
                }              
            }            
        }

        private void DropAllBorders(Grid2D<Fragment> board)
        {
            for(var y = 0; y < board.Height; y++)
            {
                for(var x = 0; x < board.Width; x++)
                {
                    board.Contents[x, y] = board.Contents[x,y].WithoutBorder();
                }
            }
        }

        private Grid2D<char> MergeBoard(Grid2D<Fragment> board)
        {
            var fragmentExample = board.Contents[0, 0];
            var combinedBoard = new Grid2D<char>(board.Width * fragmentExample.Size, board.Height * fragmentExample.Size);

            for(var y = 0; y < combinedBoard.Height; y++)
            {
                for(var x = 0; x < combinedBoard.Width; x++)
                {
                    var (FragX, FragY) = (x / fragmentExample.Size, y / fragmentExample.Size);
                    var (DataX, DataY) = (x % fragmentExample.Size, y % fragmentExample.Size);

                    combinedBoard.Contents[x, y] = board.Contents[FragX, FragY].ImageData[DataX, DataY];
                }
            }

            return combinedBoard;
        }

        private IEnumerable<Grid2D<Fragment>> DoPuzzle(Grid2D<Fragment> board, IEnumerable<Fragment> corners, IEnumerable<Fragment> borders, IEnumerable<Fragment> internalPieces)
        {
            foreach(var potentialCornerPlacement in PlaceCorners(board, corners))
            {                     
                foreach(var potentialBorderPlacement in PlaceBorders(potentialCornerPlacement, borders))
                {
                    var solutions = PlaceInternalPieces(potentialBorderPlacement, internalPieces);
                    foreach(var solution in solutions)
                    {
                        yield return solution;
                    }
                }
            }            
        }

        private IEnumerable<Grid2D<Fragment>> PlaceCorners(Grid2D<Fragment> board, IEnumerable<Fragment> corners)
        {
            var cornerPositions = new (long X, long Y)[4] { (0, 0), (0, board.Width - 1), (board.Height - 1, board.Width - 1), (board.Height - 1, 0) };
            
            foreach(var res in TryPlaceSequence(board, corners, cornerPositions))
            {
                yield return res;
            }
        }

        private IEnumerable<Grid2D<Fragment>> PlaceBorders(Grid2D<Fragment> board, IEnumerable<Fragment> borders)
        {
            var borderPositions = new List<(long X, long Y)>();
            for (var i = 1; i < board.Width - 1; i++)
            {
                borderPositions.AddRange(new (long, long)[4] { (0, i), (i, 0), (board.Height - 1, i), (i, board.Width - 1) });
            }

            foreach(var res in PlacePiecesByAdjacency(board, borders, borderPositions))
            {
                yield return res;
            }
        }

        private IEnumerable<Grid2D<Fragment>> PlaceInternalPieces(Grid2D<Fragment> board, IEnumerable<Fragment> pieces)
        {
            var positions = new List<(long X, long Y)>();

            for(var y = 1; y < board.Height - 1; y++)
            {
                for(var x = 1; x < board.Width - 1; x++)
                {
                    positions.Add((x, y));        
                }
            }

            foreach(var res in PlacePiecesByAdjacency(board, pieces, positions))
            {
                yield return res;
            }
        }

        private IEnumerable<Grid2D<Fragment>> PlacePiecesByAdjacency(Grid2D<Fragment> board, IEnumerable<Fragment> pieces, IEnumerable<(long X, long Y)> positions)
        {
            var pos = positions.First();
            var candidates = pieces;
            foreach (var direction in DirectionUtils.CardinalDirectionVectors)
            {
                var otherpos = (X: pos.X + direction.Value.DeltaX, Y: pos.Y + direction.Value.DeltaY);
                if (board.IsValidCoordinate(otherpos))
                {
                    var otherDir = DirectionUtils.RotateClockwise(direction.Key, 2);
                    var adjacencyLists = board.Contents[otherpos.X, otherpos.Y]?.AdjacencyLists;
                    if (adjacencyLists?.ContainsKey(otherDir) ?? false)
                    {
                        candidates = candidates.Intersect(adjacencyLists[otherDir]);
                    }
                }
            }

            foreach (var candidate in candidates)
            {
                foreach (var validPlacement in TryPlace(board, candidate, pos))
                {
                    if(positions.Count() > 1)
                    {
                        foreach (var res in PlacePiecesByAdjacency(validPlacement, pieces.Where(p => p.Id != candidate.Id), positions.Skip(1).ToList()))
                        {
                            yield return res;
                        }
                    }
                    else
                    {
                        yield return validPlacement;
                    }
                }
            }
        }

        private IEnumerable<Grid2D<Fragment>> TryPlaceSequence(Grid2D<Fragment> board, IEnumerable<Fragment> pieces, IEnumerable<(long X, long Y)> positions)        
        {
            var toPlace = pieces.First();
            foreach(var position in positions)
            {                
                foreach(var validPlacement in TryPlace(board, toPlace, position))
                {
                    if (pieces.Count() > 1)
                    {
                        foreach (var solution in TryPlaceSequence(validPlacement, pieces.Skip(1).ToList(), positions.Where(pos => pos != position)))
                        {
                            yield return solution;
                        }
                    }
                    else
                    {
                        yield return validPlacement;
                    }
                }
            }
        }

        private IEnumerable<Grid2D<Fragment>> TryPlace(Grid2D<Fragment> board, Fragment piece, (long X, long Y) position)
        {
            if(board.Contents[position.X, position.Y] != null)
            {
                yield break;
            }

            for (var j = 0; j < 2; j++)
            {
                for (var i = 0; i < 4; i++)
                {
                    if (PlacementIsValid(board, piece, position))
                    {
                        var copy = board.Copy();
                        copy.Contents[position.X, position.Y] = piece;
                        yield return copy;
                    }
                    piece.RotateClockwise();
                }
                piece.Flip();
            }
        }

        private bool PlacementIsValid(Grid2D<Fragment> board, Fragment piece, (long X, long Y) position)
        {
            foreach(var direction in DirectionUtils.CardinalDirectionVectors)
            {
                var otherPos = (X: position.X + direction.Value.DeltaX, Y: position.Y + direction.Value.DeltaY);
                if (board.IsValidCoordinate(otherPos) && piece.Edges[direction.Key] != null)
                {
                    var otherPiece = board.Contents[otherPos.X, otherPos.Y];
                    if (otherPiece != null && !piece.Edges[direction.Key].SequenceEqual(otherPiece.Edges[DirectionUtils.RotateClockwise(direction.Key, 2)]))
                    {
                        return false;
                    }
                }
                else if (piece.Edges[direction.Key] != null)
                {
                    //Edges pointing outside the grid must be null
                    return false;
                }                
            }

            return true;
        }

        private IEnumerable<Fragment> GetAdjacencyList(char[] thisEdge, IEnumerable<Fragment> otherFragments)
        {
            return otherFragments.Where(f => AnyEdgeMatch(thisEdge, f));            
        }

        private bool AnyEdgeMatch(char[] edge, Fragment fragment)
        {
            var revEdge = edge.Reverse();
            return fragment.Edges.Values.Any(e => (e?.SequenceEqual(edge) ?? false) || (e?.SequenceEqual(revEdge)  ?? false));
        }

        private IEnumerable<(CardinalDirection, char[])> GetMatchedEdges(Fragment fragment, IEnumerable<char[]> allEdges)
        {            
            foreach(var edge in fragment.Edges.Where(e => e.Value != null))
            {
                if(allEdges.Count(e => e.SequenceEqual(edge.Value)) > 1)
                {
                    yield return (edge.Key, edge.Value);
                }
            }
        }

        private Fragment ClearUnmatchedEdges(Fragment fragment, IEnumerable<char[]> allEdges)
        {
            foreach(var edge in fragment.Edges.Where(e => e.Value != null))
            {
                if(allEdges.Count(e => e.SequenceEqual(edge.Value)) < 2)
                {
                    fragment.Edges[edge.Key] = null;
                }
            }

            return fragment;
        }

        private int CountMonsters(Grid2D<char> image)
        {
            var found = 0;

            var monsterLength = SeaMonster.Sum(pair => pair.DeltaX);
            var maxX = image.Width - monsterLength;
            var minY = 1;
            var maxY = image.Height - 1;

            for (var y = minY; y < maxY; y++)
            {
                for (var x = 0; x < maxX; x++)
                {
                    if(IsMonster(image, (x, y)))
                    {
                        found++;
                    }
                }
            }

            return found;
        }

        private bool IsMonster(Grid2D<char> img, (int X, int Y) coord)
        {
            var currentCord = coord;
            for(var i = 0; i < SeaMonster.Length; i++)
            {
                var (DeltaX, DeltaY) = SeaMonster[i];
                currentCord = (currentCord.X + DeltaX, currentCord.Y + DeltaY);
                if(img.Contents[currentCord.X, currentCord.Y] != '#')
                {
                    return false;
                }
            }
            return true;
        }
    }
}
