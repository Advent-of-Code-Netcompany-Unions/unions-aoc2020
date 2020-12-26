using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _22._December
{
    class December22Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var rawDecks = await InputHelper.GetStringsGroupedByEmptyLine(filename);

            var decks = rawDecks.Select(d => new Deck(d)).ToList();

            var (Winner, Score) = PlayNormalGame(decks[0], decks[1]);                      

            Console.WriteLine($"Res1 {Score}");

            decks = rawDecks.Select(d => new Deck(d)).ToList();
            var game2Winner = PlayRecursiveGame(decks[0], decks[1]);
            var winningScore = game2Winner == 1 ? decks[0].Score() : decks[1].Score();

            Console.WriteLine($"Res2 {winningScore}");
        }

        public (int Winner, long Score) PlayNormalGame(Deck deck1, Deck deck2)
        {
            var done = false;
            while (!done)
            {
                var val1 = deck1.Draw();
                var val2 = deck2.Draw();

                if (val1 > val2)
                {
                    deck1.AddCardsToBottom(new[] { val1, val2 });
                }
                else
                {
                    deck2.AddCardsToBottom(new[] { val2, val1 });
                }

                done = deck1.IsEmpty() || deck2.IsEmpty();
            }

            var winningDeck = deck1.IsEmpty() ? 2 : 1;
            return winningDeck == 1 ? (1, deck1.Score()) : (2, deck2.Score());
        }

        public int PlayRecursiveGame(Deck deck1, Deck deck2)
        {
            var knownGameStates = new List<(LinkedList<int> Deck1, LinkedList<int> Deck2)>();
            var done = false;
            while (!done)
            {
                //Check for known game state
                if (knownGameStates.Any(state => state.Deck1.SequenceEqual(deck1.Cards) && state.Deck2.SequenceEqual(deck2.Cards)))
                {
                    return 1;
                }
                knownGameStates.Add((new LinkedList<int>(deck1.Cards), new LinkedList<int>(deck2.Cards)));

                var val1 = deck1.Draw();
                var val2 = deck2.Draw();

                var res = 0;
                if (val1 > deck1.Cards.Count || val2 > deck2.Cards.Count)
                {
                    res = val1 > val2 ? 1 : 2;
                }
                else
                {
                    res = PlayRecursiveGame(deck1.Copy(val1), deck2.Copy(val2));
                }

                if (res == 1)
                {
                    deck1.AddCardsToBottom(new int[] { val1, val2 });
                }
                else
                {
                    deck2.AddCardsToBottom(new int[] { val2, val1 });
                }

                done = deck1.IsEmpty() || deck2.IsEmpty();
            }
            
            return deck1.IsEmpty() ? 2 : 1;
        }
    }
}
