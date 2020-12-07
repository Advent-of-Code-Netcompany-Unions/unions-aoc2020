namespace AoCLib.DAG
{
    public class GraphEdge<T>
    {
        public GraphNode<T> From { get; init; }
        public GraphNode<T> To { get; init; }
        public T Cost { get; init; }
    }
}
