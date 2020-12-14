using AoCLib;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace _14._December
{
    class December14Solver : ChallengeSolver
    {
        private const long MAX_INT = 68719476735;

        private Dictionary<long, long> Memory;
        private char[] CurrentMask;

        public override IEnumerable<string> GetInputFiles()
        {
            return new string[] { "example2.txt", "input.txt" };
        }

        public override async Task Solve(string filename)
        {           
            var input = await InputHelper.ReadStrings(filename);
            var instructions = input.Select(inp => new Instruction(inp));
            
            Console.WriteLine($"Res1: {SolveTask1(instructions)}");
            Console.WriteLine($"Res2: {SolveTask2(instructions)}");
        }
        
        private long SolveTask1(IEnumerable<Instruction> instructions)
        {
            Memory = new Dictionary<long, long>();
            CurrentMask = null;

            foreach (var inst in instructions)
            {
                if (inst.InstructionType == Instruction.Type.Mask)
                {
                    CurrentMask = inst.Mask.ToCharArray();
                }
                else
                {
                    if (!Memory.ContainsKey(inst.Address))
                    {
                        Memory[inst.Address] = 0;
                    }

                    var valBits = ReadBits(inst.Value);
                    var maskedBits = ApplyMask(valBits);
                    Memory[inst.Address] = ReadLong(maskedBits);
                }
            }

            return Memory.Values.Sum();
        }

        private long SolveTask2(IEnumerable<Instruction> instructions)
        {
            Memory = new Dictionary<long, long>();
            CurrentMask = null;

            foreach (var inst in instructions)
            {
                if (inst.InstructionType == Instruction.Type.Mask)
                {
                    CurrentMask = inst.Mask.ToCharArray();
                }
                else
                {
                    var addresses = GetMatchingAddresses(inst.Address);

                    foreach (var address in addresses)
                    {
                        if (!Memory.ContainsKey(inst.Address))
                        {
                            Memory[inst.Address] = 0;
                        }

                        Memory[address] = inst.Value;
                    }
                }
            }

            return Memory.Values.Sum();
        }

        private BitArray ApplyMask(BitArray bits)
        {
            var ones = CurrentMask.Select(c => c == '1').ToArray();
            var zeroes = CurrentMask.Select(c => c != '0').ToArray();
            var maskedBits = bits.Or(new BitArray(ones)).And(new BitArray(zeroes));
            return maskedBits;
        }

        private BitArray ReadBits(long num)
        {            
            if(num > MAX_INT)
            {
                throw new Exception("Input out of range");
            }

            var res = new BitArray(36);
            var toParse = num;
            for(var i = 0; i < res.Length; i++)
            {
                var posVal = GetPositionValue(i);
                res[i] = (toParse / posVal) > 0;
                toParse %= posVal;
            }

            return res;            
        }

        private long ReadLong(BitArray bits)
        {
            var sum = 0L;
            for(var i = 0; i < bits.Length; i++)
            {
                if(bits[i])
                {
                    sum += GetPositionValue(i);
                }
            }

            return sum;
        }

        private long GetPositionValue(int index)
        {
            return (long) Math.Pow(2, 35 - index);
        }

        private IEnumerable<long> GetMatchingAddresses(long address)
        {
            var bits = ReadBits(address);
            var addresses = ExpandAddress(bits, 0);
            return addresses.Select(ReadLong);            
        }

        private IEnumerable<BitArray> ExpandAddress(BitArray bits, int index)
        {
            var res = new List<BitArray>();            

            //Base case
            if(index >= bits.Length)
            {
                return res;
            }

            var subResults = ExpandAddress(bits, index + 1);

            var currentChar = CurrentMask[index];
            if(currentChar == '0')
            {
                res = Combine(bits[index], subResults);                
            }
            if(currentChar == '1')
            {
                res = Combine(true, subResults);                
            }
            if(currentChar == 'X')
            {
                res = Combine(true, subResults);
                res.AddRange(Combine(false, subResults));
            }

            return res;                
        }

        private List<BitArray> Combine(bool val, IEnumerable<BitArray> subResults)
        {
            var res = new List<BitArray>();

            if (!subResults.Any())
            {
                res.Add(new BitArray(new bool[] { val }));
            }

            foreach (var subResult in subResults)
            {
                var temp = new bool[subResult.Length + 1];
                subResult.CopyTo(temp, 0);
                temp[subResult.Length] = val;
                res.Add(new BitArray(temp));
            }

            return res;
        }
    }    
}
