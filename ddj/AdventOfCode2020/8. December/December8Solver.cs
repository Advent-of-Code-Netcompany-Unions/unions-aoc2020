using AoCLib;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _8._December
{
    class December8Solver : ChallengeSolver
    {
        public override async Task Solve(string filename)
        {
            var input = await InputHelper.ReadStrings(filename);
            var instructions = Compile(input).ToList();

            var program = new BootProgram(instructions);
            var res = program.Run();

            if (res == -1)
            {
                Console.WriteLine($"Res1: {program.Accumulator}");
            }

            int i = 0;
            while(i < instructions.Count)
            {
                if(instructions[i].InstructionType != BootProgram.InstructionType.acc)
                {
                    var modifiedInstructions = instructions.ToArray();
                    modifiedInstructions[i] = ModifyInstruction(instructions[i]);
                    var modifiedProgram = new BootProgram(modifiedInstructions);
                    res = modifiedProgram.Run();
                    if (res == 0)
                    {
                        Console.WriteLine($"Res2: {modifiedProgram.Accumulator}");
                    }
                }

                i++;
            }
        }

        private IEnumerable<BootProgram.Instruction> Compile(IEnumerable<string> programCode)
        {
            return programCode.Select(CompileInstruction);
        }

        private BootProgram.Instruction CompileInstruction(string line)
        {
            var parts = line.Split(" ");
            var instr = Enum.Parse(typeof(BootProgram.InstructionType), parts[0]);
            var value = int.Parse(parts[1]);

            return new BootProgram.Instruction { InstructionType = (BootProgram.InstructionType)instr, Offset = value };
        }

        private BootProgram.Instruction ModifyInstruction(BootProgram.Instruction instr)
        {
            var newInstr = instr;
            if(instr.InstructionType == BootProgram.InstructionType.jmp)
            {
                newInstr = new BootProgram.Instruction { InstructionType = BootProgram.InstructionType.nop, Offset = instr.Offset };
            }
            else if(instr.InstructionType == BootProgram.InstructionType.nop)
            {
                newInstr = new BootProgram.Instruction { InstructionType = BootProgram.InstructionType.jmp, Offset = instr.Offset };
            }

            return newInstr;
        }
    }
}
