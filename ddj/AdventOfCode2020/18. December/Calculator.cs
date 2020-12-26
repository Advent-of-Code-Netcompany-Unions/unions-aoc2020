using System;

namespace _18._December
{
    class Calculator
    {
        private readonly string Expression;
        private readonly bool PlusHasPrecedence;
        private int Index;

        public Calculator(string expr, bool plusHasPrecedence)
        {
            Expression = expr.Replace(" ", "");
            PlusHasPrecedence = plusHasPrecedence;
        }

        public long ComputeResult()
        {
            var res = GetNumber();
            while (Index < Expression.Length)
            {
                if (Expression[Index] == ')')
                {
                    return res;
                }

                var op = GetOperation();

                res = PerformOperation(op, res);
            }
            return res;
        }

        private long PerformOperation(char op, long currentVal)
        {
            return op switch
            {
                '+' => PerformAddition(currentVal),
                '*' => PerformMultiplication(currentVal),
                _ => throw new Exception("Unknown operation: " + op),
            };
        }

        private long PerformAddition(long currentVal)
        {
            return currentVal + GetNumber();
        }

        private long PerformMultiplication(long currentVal)
        {
            var num = GetNumber();

            if (PlusHasPrecedence)
            {
                while (Index < Expression.Length)
                {
                    var nextChar = Expression[Index];
                    if (nextChar == ')' || nextChar == '*')
                    {
                        break;
                    }

                    var op = GetOperation();
                    num = PerformOperation(op, num);
                }
            }

            return num * currentVal;
        }

        private long GetNumber()
        {
            if (Expression[Index] == '(')
            {
                return EvaluateParentheses();
            }

            var part = Expression[Index..].Split(new char[] { '*', '+', ')' })[0];
            Index += part.Length;
            return long.Parse(part);
        }

        private long EvaluateParentheses()
        {
            Index++;
            var res = ComputeResult();
            Index++;
            return res;
        }

        private char GetOperation()
        {
            var res = Expression[Index];
            Index++;
            return res;
        }
    }
}
