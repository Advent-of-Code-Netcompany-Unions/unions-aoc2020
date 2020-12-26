namespace AoCLib.CircularList
{
    public class CircularListNode<T>
    {
        public CircularListNode<T> Next { get; set; }
        public CircularListNode<T> Previous { get; set; }

        public T Value { get; init; }

        public CircularListNode(T val)
        {
            Value = val;
        }

        public void Remove()
        {
            Next.Previous = Previous;
            Previous.Next = Next;
            Next = null;
            Previous = null;            
        }
    }
}
