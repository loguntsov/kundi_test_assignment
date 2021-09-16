all: compile

compile: deps
	mix compile

deps:
	mix deps.get

.PHONY: clean
clean:
	mix clean

.PHONY: run
run: all
	iex -S mix
