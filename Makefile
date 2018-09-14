build/toycalc: toycalc.d
	dmd toycalc.d -od=build -of=build/toycalc

.PHONY: clean test
clean:
	rm -r build

test: build/toycalc
	sh test.sh
