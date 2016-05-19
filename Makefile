MOON   = $(shell find -name '*.moon')
NATIVE = $(shell find lib -name '*.lua') main.lua conf.lua
ASSETS = $(shell find assets)
COMPILED  = $(MOON:.moon=.lua)

LOVE = $(NATIVE) $(ASSETS) $(COMPILED) heythere.txt

.PHONY: all run cleanmoon cleanlove clean
all: game.love

run:
	love .

clean: cleanmoon cleanlove
cleanmoon:
	rm $(COMPILED)

cleanlove:
	rm game.love

$(COMPILED): %.lua: %.moon
	@moonc $?

game.love: $(LOVE)
	@zip -g $@ $?
