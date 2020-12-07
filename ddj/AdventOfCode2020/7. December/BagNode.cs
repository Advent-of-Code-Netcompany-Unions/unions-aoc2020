using AoCLib.DAG;
using System;
using System.Linq;

namespace _7._December
{
    public class BagNode : GraphNode<long?>
    {
        public BagNode(string name) : base(name)
        {            
        }

        public bool CanComputeNumBags()
        {
            return Connections.All(edge => edge.To.Value.HasValue);
        }

        public void ComputeNumBags()
        {
            if (!CanComputeNumBags())
            {
                throw new Exception("Insufficient data to compute number of bags");
            }
            var sum = Connections.Select(edge => edge.To.Value * edge.Cost).Sum();
            this.Value = sum + 1; //Add self
        }        
    }
}
