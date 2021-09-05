.PHONY: build
build:
	elm make src/Main.elm
	mv index.html public/index.html

.PHONY: all
format:
	elm-format src/

.PHONY: live
live:
	elm-live src/Main.elm --pushstate
