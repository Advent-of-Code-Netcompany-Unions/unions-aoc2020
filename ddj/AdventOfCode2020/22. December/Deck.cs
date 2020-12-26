using System;
using System.Collections.Generic;
using System.Linq;

namespace _22._December
{
    class Deck
    {
        public LinkedList<int> Cards { get; init; } = new LinkedList<int>();

        public Deck(IEnumerable<string> rawDeck)
        {
            foreach(var card in rawDeck.Skip(1))
            {
                Cards.AddLast(int.Parse(card));
            }
        }

        public Deck(IEnumerable<int> cards)
        {
            Cards = new LinkedList<int>(cards);
        }

        public Deck Copy(int n)
        {
            return new Deck(Cards.Take(n));
        }

        public int Draw()
        {
            var res = Cards.First();
            Cards.RemoveFirst();
            return res;
        }

        public void AddCardsToBottom(int[] cards)
        {
            foreach(var card in cards)
            {
                Cards.AddLast(card);
            }
        }

        public long Score()
        {
            var sum = 0;
            var cards = Cards.ToArray();
            for(var i = 0; i < Cards.Count; i++)
            {
                var index = Cards.Count - i - 1;
                sum += (i + 1) * cards[index];
            }

            return sum;
        }

        public bool IsEmpty()
        {
            return Cards.Count == 0;
        }
    }
}
