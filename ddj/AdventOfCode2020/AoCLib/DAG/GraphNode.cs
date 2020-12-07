using System.Collections.Generic;
using System.Linq;

namespace AoCLib.DAG
{
    public class GraphNode<T>
    {
        public string Name { get; init; }

        public T Value { get; set; }

        public ISet<GraphEdge<T>> Connections { get; init; }

        public GraphNode(string name)
        {
            Name = name;
            Connections = new HashSet<GraphEdge<T>>();
        }

        public bool IsConnectedTo(string nodeName)
        {
            if (this.Name == nodeName)
            {
                return true;
            }

            return Connections.Any(edge => edge.To.IsConnectedTo(nodeName));
        }
    }
}
