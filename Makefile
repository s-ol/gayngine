MOON   = $(shell find -name '*.moon')
NATIVE = $(shell find lib -name '*.lua') main.lua conf.lua
SCENES = $(shell find game -name '*.psd')
ASSETS = $(shell find assets) $(shell find shaders)
COMPILED  = $(MOON:.moon=.lua)

LOVE = $(NATIVE) $(SCENES) $(ASSETS) $(COMPILED) heythere.txt

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
