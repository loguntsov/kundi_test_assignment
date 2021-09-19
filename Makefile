MIX_ENV ?= dev

all: compile docs

compile: deps
	mix compile

deps: mix.exs
	mix deps.get

.PHONY: clean
clean:
	mix clean
	rm -rf deps
	rm -rf doc

.PHONY: run
run: all
	iex -S mix

.PHONY:
start: release
	./_build/${MIX_ENV}/rel/kundi/bin/kundi daemon

stop:
	./_build/${MIX_ENV}/rel/kundi/bin/kundi stop

.PHONY: docs
docs: deps
	mix docs

release: all
	mix release --overwrite

.PHONY: test
test:
	mix test
