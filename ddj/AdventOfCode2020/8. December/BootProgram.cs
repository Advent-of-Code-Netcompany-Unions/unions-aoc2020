using System.Collections.Generic;
using System.Linq;

namespace _8._December
{
    public class BootProgram
    {
        public long Accumulator;
        private int InstructionPointer;        
        private readonly Instruction[] Program;
        private readonly bool[] VisitedLines;

        public enum InstructionType {acc, jmp, nop };

        public class Instruction
        {
            public InstructionType InstructionType { get; set; }
            public int? Offset { get; init; }
        }
        
        public BootProgram(IEnumerable<Instruction> instructions)
        {
            InstructionPointer = 0;
            Accumulator = 0;
            Program = instructions.ToArray();
            VisitedLines = new bool[Program.Length];
        }

        public int Run()
        {
            while(!VisitedLines[InstructionPointer])
            {              
                VisitedLines[InstructionPointer] = true;
                RunInstruction(Program[InstructionPointer]);                
                if(InstructionPointer >= Program.Length)
                {
                    return 0;
                }
            }

            return -1;
        }

        private void RunInstruction(Instruction instr)
        {
            switch(instr.InstructionType)
            {
                case InstructionType.nop:
                    Nop();
                    return;
                case InstructionType.acc:
                    Acc(instr.Offset.Value);
                    return;
                case InstructionType.jmp:
                    Jmp(instr.Offset.Value);
                    return;
            }
        }

        private void Acc(int value)
        {
            Accumulator += value;
            InstructionPointer++;
        }

        private void Nop()
        {
            InstructionPointer++;
        }

        private void Jmp(int offset)
        {
            InstructionPointer += offset;
        }
    }
}
