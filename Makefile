.PHONY: build all run clean

build:
	@dune build && rm -f ./brack && cp _build/default/bin/main.exe ./brack

default:build

all:build

run:build
	@_build/default/bin/main.exe && dot -Tpng -O *.dot

clean:
	@dune clean && rm -f *.dot *.png && rm -f brack
