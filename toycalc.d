struct State
{
    string inp;
    size_t i;
    long[26] args;
    string[26] func;
}

void main(string[] args)
{
    import std.stdio : writeln;
    import std.array : join;

    State s;

    s.inp = args[1 .. $].join(' ');

    while (s.i < s.inp.length)
    {
        eval(s).writeln;
    }
}

long eval(ref State s)
{
    import std.ascii : isDigit, isUpper, isLower, isAlpha;
    import std.algorithm.comparison : among;
    import std.stdio : writeln;

    skip(s);

    if (s.inp.length <= s.i)
    {
        return 0;
    }

    if (s.inp[s.i].isDigit)
    {
        long val = cast(long)(s.inp[s.i++] - '0');

        while (s.i < s.inp.length && s.inp[s.i].isDigit)
        {
            val = val * 10 + cast(long)(s.inp[s.i++] - '0');
        }
        return val;
    }

    if (s.inp[s.i].among!('+', '-', '*', '/'))
    {
        char op = s.inp[s.i];
        s.i++;
        long l = eval(s);
        long r = eval(s);

        switch (op)
        {
        case '+':
            return l + r;
        case '-':
            return l - r;
        case '*':
            return l * r;
        case '/':
            return l / r;
        default:
            assert(0);
        }
    }

    if (s.inp[s.i] == 'P')
    {
        s.i += 2;
        long val = eval(s);
        val.writeln;
        s.i += 2;
        return val;
    }

    if (s.inp[s.i].isAlpha && s.inp[s.i].isLower)
    {
        char name = s.inp[s.i];
        s.i++;
        return s.args[cast(size_t)(name - 'a')];
    }

    if (s.inp[s.i].isAlpha && s.inp[s.i].isUpper && s.inp[s.i + 1] == '[')
    {
        char name = s.inp[s.i];
        s.i += 2;
        s.func[cast(size_t)(name - 'A')] = readUntil(s, ']');
        return eval(s);
    }

    if (s.inp[s.i].isAlpha && s.inp[s.i].isUpper && s.inp[s.i + 1] == '(')
    {
        char name = s.inp[s.i];
        s.i += 2;

        State f = s;
        f.inp = s.func[cast(size_t)(name - 'A')];
        f.i = 0;

        skip(s);
        size_t i = 0;
        while (s.i < s.inp.length && s.inp[s.i] != ')')
        {
            f.args[i] = eval(s);
            i++;
            skip(s);
        }

        s.i += 2;

        long result;
        while (f.i < f.inp.length)
            result = eval(f);
        return result;
    }

    throw new Error("invald charactor: " ~ s.inp[s.i]);
}

void skip(ref State s)
{
    import std.ascii : isWhite;

    while (s.i < s.inp.length && s.inp[s.i].isWhite)
    {
        s.i++;
    }
}

string readUntil(ref State s, char c)
{
    foreach (i, d; s.inp[s.i .. $])
    {
        if (d == c)
        {
            string result = s.inp[s.i .. s.i + i];
            s.i += i + 1;
            return result;
        }
    }
    assert(0);
}
