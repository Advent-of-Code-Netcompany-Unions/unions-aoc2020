namespace _14._December
{
    class Instruction
    {
        public enum Type { Memory, Mask }
        public Type InstructionType { get; init; }
        public long Address { get; set; }
        public long Value { get; init; }
        public string Mask { get; init; }

        public Instruction(string toParse)
        {
            var parts = toParse.Split(" = ");
            if (parts[0] == "mask")
            {
                Mask = parts[1];
                InstructionType = Type.Mask;
            }
            else
            {
                Value = long.Parse(parts[1]);
                var addrString = parts[0].Split("[")[1].Replace("]", "");
                Address = long.Parse(addrString);
            }
        }
    }
}
