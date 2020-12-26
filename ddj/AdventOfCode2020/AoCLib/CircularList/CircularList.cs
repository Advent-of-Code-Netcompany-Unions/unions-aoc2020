using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AoCLib.CircularList
{
    public class CircularList<T>
    {
        public long Count { private set; get; } = 0;
        public bool IsEmpty => Count == 0;

        public CircularListNode<T> CurrentNode { get; set; }

        public Dictionary<T, CircularListNode<T>> NodeIndex = new Dictionary<T, CircularListNode<T>>();

        public CircularList()
        { }

        public CircularList(IEnumerable<T> items)
        {
            AddBefore(items);
        }

        public void AddBefore(T item)
        {
            if(IsEmpty)
            {
                AddFirst(item);
            }
            else
            {
                AddMoreBefore(item);
            }            
        }

        public void AddBefore(IEnumerable<T> items)
        {
            if(!items.Any())
            {
                return;
            }

            AddBefore(items.First());
            foreach(var item in items.Skip(1))
            {
                AddMoreBefore(item);
            }
        }

        public void AddAfter(T item)
        {
            if(IsEmpty)
            {
                AddFirst(item);
            }
            else
            {
                AddMoreAfter(item);
            }
        }

        public void AddAfter(IEnumerable<T> items)
        {
            if(!items.Any())
            {
                return;
            }

            AddAfter(items.First());
            foreach(var item in items.Skip(1))
            {
                AddMoreAfter(item);
            }
        }

        private void AddFirst(T item)
        {
            CurrentNode = new CircularListNode<T>(item);
            NodeIndex[item] = CurrentNode;
            CurrentNode.Next = CurrentNode;
            CurrentNode.Previous = CurrentNode;
            Count++;
        }

        private void AddMoreBefore(T item)
        {
            var prev = CurrentNode.Previous;
            var newNode = new CircularListNode<T>(item);
            NodeIndex[item] = newNode;
            prev.Next = newNode;
            newNode.Previous = prev;
            newNode.Next = CurrentNode;
            CurrentNode.Previous = newNode;
            Count++;
        }

        private void AddMoreAfter(T item)
        {
            var next = CurrentNode.Next;
            var newNode = new CircularListNode<T>(item);
            NodeIndex[item] = newNode;
            next.Previous = newNode;
            newNode.Next = next;
            newNode.Previous = CurrentNode;
            CurrentNode.Next = newNode;
            Count++;
        }

        public T Current()
        {
            if(IsEmpty)
            {
                throw new IndexOutOfRangeException("No current item in empty list");
            }

            return CurrentNode.Value;
        }

        public void Next()
        {
            CurrentNode = CurrentNode.Next;
        }

        public bool Find(T item)
        {
            if(NodeIndex.ContainsKey(item))
            {
                CurrentNode = NodeIndex[item];
                return true;
            }
            return false;
        }

        public T Take()
        {
            if(IsEmpty)
            {
                throw new IndexOutOfRangeException("Can't take from empty list");
            }

            var thisNode = CurrentNode;
            Next();
            NodeIndex.Remove(thisNode.Value);
            thisNode?.Remove();
            Count--;
            return thisNode.Value;
        }

        public List<T> Take(long n)
        {
            if(n > Count)
            {
                throw new IndexOutOfRangeException($"Can't take {n} from list of length {Count}");
            }

            var res = new List<T>();
            for(var i = 0; i <n; i++)
            {
                res.Add(Take());
            }

            return res;
        }

        public IEnumerable<T> TakeLazy(long n)
        {
            for(var i = 0; i < n; i++)
            {
                yield return Take();
            }
        }

        public IEnumerable<T> ToIEnumerable()
        {            
            for(var i = 0; i < Count; i++)
            {
                yield return CurrentNode.Value;
                Next();
            }            
        }

        public List<T> ToList()
        {
            return ToIEnumerable().ToList();
        }
    }
}
