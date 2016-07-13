MOON   = $(shell find -name '*.moon')
NATIVE = $(shell find lib -name '*.lua') main.lua conf.lua
SCENES = $(shell find game -name '*.psd')
ASSETS = $(shell find assets) $(shell find shaders)
COMPILED  = $(MOON:.moon=.lua)

BIN = bin
DIST = dist
GAMENAME = two_shooting_stars
WINBINS = $(BIN)/win64/$(GAMENAME).exe $(BIN)/win32/$(GAMENAME).exe

LOVE = $(NATIVE) $(SCENES) $(ASSETS) $(COMPILED) heythere.txt

.PHONY: all run cleanmoon cleanlove clean win32 win64 mac binaries
all: game.love

run:
	love .

binaries: win32 win64 mac

clean: cleanmoon cleanlove
cleanmoon:
	rm -f $(COMPILED)

cleanlove:
	rm -f $(DIST)/$(GAMENAME).love

$(COMPILED): %.lua: %.moon
	@moonc $?

$(DIST)/$(GAMENAME).love: $(LOVE)
	mkdir -p $(DIST)
	@zip -9g $@ $?

$(BIN)/win32 $(BIN)/win64:
	mkdir -p $(BIN)
	mkdir -p $@

$(WINBINS): $(BIN)/%/$(GAMENAME).exe: $(BIN)/%
	echo $(WINBINS) ... $? ... $@
	wget https://bitbucket.org/rude/love/downloads/love-0.10.1-win64.zip -O $?.zip
	unzip -jd $? $?.zip
	mv $?/love.exe $@
	rm $?/game.ico $?/changes.txt $?/readme.txt

$(BIN)/mac: $(BIN)
	wget https://bitbucket.org/rude/love/downloads/love-0.10.1-macosx-x64.zip -O $@.zip
	mkdir -p $@
	unzip -d $@ $@.zip
	mv $@/love.app $@/$(GAMENAME).app

win32: $(DIST)/$(GAMENAME).love $(BIN)/win32/$(GAMENAME).exe
	cp -r $(BIN)/win32 $(DIST)/win32
	cat $(DIST)/$(GAMENAME).love >> $(DIST)/win32/$(GAMENAME).exe

win64: $(DIST)/$(GAMENAME).love $(BIN)/win64/$(GAMENAME).exe
	cp -r $(BIN)/win64 $(DIST)/win64
	cat $(DIST)/$(GAMENAME).love >> $(DIST)/win64/$(GAMENAME).exe

mac: $(DIST)/$(GAMENAME).love $(BIN)/mac
	cp -r $(BIN)/mac $(DIST)/mac
	cp $(DIST)/$(GAMENAME).love $(DIST)/mac/$(GAMENAME).app/Contents/Resources/
