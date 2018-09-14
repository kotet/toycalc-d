runtest() {
    output=$(./build/toycalc "$1")
	if [ "$output" != "$2" ]; then
		echo "$1: $2 expected, but got $output"
		exit 1
	fi
	echo "$1 => $output"
}

echo "=== basic ==="
runtest 0 0
runtest 1234 1234
runtest "1 2 3" "1
2
3"

echo "=== arithmetic operations ==="

runtest "++1 2 3" 6
runtest "+ 100 5" 105
runtest "- 5 1" 4
runtest "--3 2 1" 0
runtest "* 3 5" 15
runtest "/ 20 4" 5

echo "=== functions ==="

runtest "F[+ a a] F(1)" 2
runtest "F[* a 2] F(5)" 10
runtest "F[* a a] F(F(2))" 16
runtest "F[* a a] F(F(F(2)))" 256
runtest "F[* a b] F(3 5)" 15

echo "=== built-in function ==="

runtest "P(5)" "5
5"

echo OK