MIX_ENV ?= dev

all: compile

compile: deps
	mix compile

deps:
	mix deps.get

.PHONY: clean
clean:
	mix clean
	rm -rf deps

.PHONY: run
run: all
	iex -S mix

.PHONY:
start: release
	./_build/${MIX_ENV}/rel/kundi/bin/kundi daemon

stop:
	./_build/${MIX_ENV}/rel/kundi/bin/kundi stop

release: all
	mix release --overwrite
