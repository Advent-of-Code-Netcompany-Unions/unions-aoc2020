using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _24._December
{
    public enum HexagonalDirection { NORTH_EAST, EAST, SOUTH_EAST, SOUTH_WEST, WEST, NORTH_WEST }    

    class December24Solver : ChallengeSolver
    {
        public static Dictionary<HexagonalDirection, (int DeltaX, int DeltaY)> DirectionVectors = new Dictionary<HexagonalDirection, (int, int)>()
        {
            { HexagonalDirection.NORTH_EAST, (1, 1) },
            { HexagonalDirection.EAST, (2, 0) },
            { HexagonalDirection.SOUTH_EAST, (1, -1) },
            { HexagonalDirection.SOUTH_WEST, (-1, -1) },
            { HexagonalDirection.WEST, (-2, 0) },
            { HexagonalDirection.NORTH_WEST, (-1, 1) }
        };

        public override async Task Solve(string filename)
        {
            var input = (await InputHelper.ReadStrings(filename)).Select(GetDirections);

            var tiles = new Dictionary<(int, int), bool>();
            var startTile = (X: 0, Y: 0);
            foreach(var tileToFlip in input)
            {
                var tile = startTile;
                foreach(var direction in tileToFlip)
                {
                    tile = (tile.X + DirectionVectors[direction].DeltaX, tile.Y + DirectionVectors[direction].DeltaY);
                }

                tiles[tile] = !tiles.ContainsKey(tile) || !tiles[tile];               
            }

            var res1 = tiles.Values.Count(b => b);
            Console.WriteLine($"Res1: {res1}");

            var updatedTiles = UpdateTiles(tiles, 100);

            var res2 = updatedTiles.Values.Count(b => b);
            Console.WriteLine($"Res2: {res2}");
        }

        public Dictionary<(int, int), bool> UpdateTiles(Dictionary<(int, int), bool> startState, int iterations)
        {
            var state = startState;
            for(var i = 0; i < iterations; i++)
            {
                var newState = new Dictionary<(int, int), bool>(state);
                foreach(var entry in state.Where(entry => entry.Value))
                {
                    //Check self
                    var adjacent = GetCurrentAdjacent(entry.Key, state);
                    var unflippedAdjacents = adjacent.Where(tile => !tile.Flipped);
                    newState[entry.Key] = unflippedAdjacents.Count() > 3 && unflippedAdjacents.Count() < 6;

                    //Check white adjacent
                   foreach(var (Pos, _) in unflippedAdjacents)
                   {
                        if(GetCurrentAdjacent(Pos, state).Count(tile => tile.Flipped) == 2)
                        {
                            newState[Pos] = true;
                        }
                   }
                }

                state = newState;
            }

            return state;
        }

        public IEnumerable<((int X, int Y) Pos, bool Flipped)> GetCurrentAdjacent((int X, int Y) tile, Dictionary<(int, int), bool> state)
        {
            return DirectionVectors
                .Values
                .Select(vec => (tile.X + vec.DeltaX, tile.Y + vec.DeltaY))
                .Select(pos => (pos, state.ContainsKey(pos) ? state[pos] : false));
        }

        public IEnumerable<HexagonalDirection> GetDirections(string rawInput)
        {
            var toParse = rawInput;
            while (toParse.Length > 0)
            {
                switch (toParse)
                {
                    case string s when s.StartsWith('e'):
                        toParse = toParse[1..];
                        yield return HexagonalDirection.EAST;                        
                        continue;
                    case string s when s.StartsWith('w'):
                        toParse = toParse[1..];
                        yield return HexagonalDirection.WEST;                        
                        continue;
                    case string s when s.StartsWith("se"):
                        toParse = toParse[2..];
                        yield return HexagonalDirection.SOUTH_EAST;                        
                        continue;
                    case string s when s.StartsWith("ne"):
                        toParse = toParse[2..];
                        yield return HexagonalDirection.NORTH_EAST;                        
                        continue;
                    case string s when s.StartsWith("sw"):
                        toParse = toParse[2..];
                        yield return HexagonalDirection.SOUTH_WEST;                        
                        continue;
                    case string s when s.StartsWith("nw"):
                        toParse = toParse[2..];
                        yield return HexagonalDirection.NORTH_WEST;                        
                        continue;
                }
            }
        }
    }
}
