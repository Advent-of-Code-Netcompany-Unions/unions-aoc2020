using System.Collections.Generic;
using System.Linq;

namespace AoCLib.DAG
{
    public class DirectedAcyclicGraph<T, Y> where T : GraphNode<Y>
    {
        public ISet<T> Nodes { get; init; }

        public DirectedAcyclicGraph()
        {
            Nodes = new HashSet<T>();
        }

        public DirectedAcyclicGraph(IEnumerable<T> nodes)
        {
            Nodes = nodes.ToHashSet();
        }
    }
}
