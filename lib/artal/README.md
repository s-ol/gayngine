# **Artal**
### A .PSD parsing library for LÖVE

https://love2d.org/

Purpose is to expose the structure of .PSD files into LÖVE.
- ImageData for the layers.
- Names.
- Blendmodes.
- Clipping mode.
- Structure, folder / image.


Adobe documentation on the PSD file format: http://www.adobe.com/devnet-apps/photoshop/fileformatashtml/

![](https://u.pomf.is/sbzsva.gif)

## artal.lua
```lua
artal = require("artal")
psdTable = artal.newPSD(FileNameOrFileData) -- full structure with the layers loaded in as images.
psdTable = artal.newPSD(FileNameOrFileData, "info") -- full structure.
ImageDataOrNil = artal.newPSD(FileNameOrFileData, layerNumber) -- ImageData for the specified layer number.
ImageData = artal.newPSD(FileNameOrFileData, "composed")
-- ImageData of the composed image as it's stored in the psd file itself.
-- Note that Photoshop has an slightly erroneous implementation composing the alpha into the composed image.
-- So images without a fully opaque background will be slightly blended with white.
```

### Sample code:
![](https://u.pomf.is/klltkn.png)
```lua
local artal = require("artal")
love.graphics.setBackgroundColor(255,255,255)

img = artal.newPSD("sample.psd")

function love.draw()
	for i = 1, #img do
        love.graphics.draw(
            img[i].image,
            nil, -- Position X
            nil, -- Position Y
            nil, -- Rotation
            nil, -- Scale X
            nil, -- Scale Y
            img[i].ox, -- Offset X
            img[i].oy) -- Offset Y
    end
end
```

### Full structure artal extracts from the psd.
![](https://u.pomf.is/vrwgck.png)
```lua
local artal = require("artal")
love.graphics.setBackgroundColor(255,255,255)

img = artal.newPSD("sample.psd")

function love.draw()

	-- Image info.
	love.graphics.setColor(0,0,0)
	love.graphics.print("Global Image info", 0, 14*0)
	love.graphics.print("Layer Count: "..#img, 0, 14*1)
	love.graphics.print("Width: "..img.width, 0, 14*2)
	love.graphics.print("Height: "..img.height, 0, 14*3)
	for i = 1, #img do
		love.graphics.setColor(0,0,0)
		love.graphics.print("Layer index: "..i, (i-1)*200, 70+14*0)
		love.graphics.print("name: "..img[i].name, (i-1)*200, 70+14*1)
		love.graphics.print("type: "..img[i].type, (i-1)*200, 70+14*2)
		love.graphics.print("blend: "..img[i].blend, (i-1)*200, 70+14*3)
		love.graphics.print("clip: "..tostring(img[i].clip), (i-1)*200, 70+14*4)
		love.graphics.print("ox: "..img[i].ox, (i-1)*200, 70+14*5)
		love.graphics.print("oy: "..img[i].oy, (i-1)*200, 70+14*6)
		love.graphics.print("getWidth: "..img[i].image:getWidth(), (i-1)*200, 70+14*7)
		love.graphics.print("getHeight: "..img[i].image:getHeight(), (i-1)*200, 70+14*8)
		
		-- Bounding Boxes
		love.graphics.rectangle(
			"line",
			(i-1)*200-img[i].ox-0.5,
			70+14*9-img[i].oy-0.5,
			img[i].image:getWidth()+1,
			img[i].image:getHeight()+1)

		love.graphics.setColor(255,255,255)
		love.graphics.draw(
			img[i].image,
			(i-1)*200,
			70+14*9,
			nil,
			nil,
			nil,
			img[i].ox,
			img[i].oy)
	end
	
end
```
### Layer Types
These are the type of layers
```
"image" = image layer with imagedata.
"empty" = image layer without imagedata.
"open" = folder layer.
"close" = folder layer.
```

### Blend Modes
These are all blendmodes available.
```
There's sample code for these first 5 blendmodes.
"norm" = normal
"pass" = pass through
"mul"  = multiply
"scrn" = screen
"over" = overlay

"diss" = dissolve
"dark" = darken
"idiv" = color burn
"lbrn" = linear burn
"dkCl" = darker color
"lite" = lighten
"div"  = color dodge
"lddg" = linear dodge
"lgCl" = lighter color
"sLit" = soft light
"hLit" = hard light
"vLit" = vivid light
"lLit" = linear light
"pLit" = pin light
"hMix" = hard mix
"diff" = difference
"smud" = exclusion
"fsub" = subtract
"fdiv" = divide
"hue"  = hue
"sat"  = saturation
"colr" = color
"lum"  = luminosity
```

### Loading specific layers.
![](https://u.pomf.is/exmlfg.png)
```lua
local artal = require("artal")
love.graphics.setBackgroundColor(255,255,255)

local fileData = love.filesystem.newFileData("sample.psd")
img = artal.newPSD(fileData,"info")

for i = 1, #img do
	if img[i].type == "image" and string.find(img[i].name, "Blob") then -- Only load layers with Blob in the name
		img[i].image = love.graphics.newImage(artal.newPSD(fileData, i))
	end
end

function love.draw()
	for i = 1, #img do
		if img[i].image then
	        love.graphics.draw(
	            img[i].image,
	            nil,
	            nil,
	            nil,
	            nil,
	            nil,
	            img[i].ox,
	            img[i].oy)
	    end
    end
end
```

### writetable.lua
Create a string from tables. So you can inspect tables created by artal.newPSD(). The structure below is generated from writetable.lua. And you can use that to visualize your own tables as well.
```lua
local writetable = require("writetable")
tableAsString = writetable.createStringFromTable(table)
```

```lua
{
	-- Table with 4 indexes, and 2 string keys.
	-- Array values are all of type: "table".
	height = 200,
	width = 200,
	[1] = 
	{
		-- Table with 7 string keys.
		oy = 0,
		image = "Image: 0x6b119bff80",
		ox = 0,
		type = "image",
		blend = "norm",
		name = "Background",
		clip = false,
	},
	[2] = 
	{
		-- Table with 7 string keys.
		oy = -40,
		image = "Image: 0x6b119c0140",
		ox = -68,
		type = "image",
		blend = "norm",
		name = "Red Blob",
		clip = false,
	},
	[3] = 
	{
		-- Table with 7 string keys.
		oy = -17,
		image = "Image: 0x6b119c0220",
		ox = -95,
		type = "image",
		blend = "norm",
		name = "Blue Blob",
		clip = true,
	},
	[4] = 
	{
		-- Table with 7 string keys.
		oy = -27,
		image = "Image: 0x6b12844c80",
		ox = -8,
		type = "image",
		blend = "over",
		name = "Multiple Blobs",
		clip = true,
	},
}
```

### psdShader.lua:
NOTE: This library is very much incomplete. But it's at least a starting point for you to understand how you can create shaders that mimics photoshop effects.

It generates shaders for blending and clipping layers.
Blendmodes implemented: Alpha, Multiply, Screen and Overlay.

It may require a "Swap canvas" system If you need a global blend mode. See below for samples.
```lua
local psdShader = require("psdShader")

-- If you pass in "mul", "scrn" or "over" to globalBlendmode the shader generated will require a swapcanvas.
shaderString = psdShader.createShaderString(globalBlendmode, blendmodeBeingClipped, ...)

-- Passing in canvas is only required if you use a shader with globalBlendmode: mul, scrn, over.
psdShader.setShader(shader, canvas1, canvas2) 

-- Rotation and shearing not implemented. love.graphics.push() and friends does not work either.
-- The image that is passed in is also retained. Unlike love.graphics.draw().
psdShader.drawClip(drawOrderIndex,image,x,y,r,sx,sy,ox,oy,kx,ky) 
resultCanvas = psdShader.flatten(psdTableClipTo, psdTableBeingClipped, ...)
```
### Clipping sample
![](https://u.pomf.is/ubvsna.png)
```lua
local artal = require("artal")
local psdShader = require("psdShader")
love.graphics.setBackgroundColor(255,255,255)

img = artal.newPSD("sample.psd")

local blendShader = {}
blendShader.clip = love.graphics.newShader(psdShader.createShaderString("norm", "norm", "over"))

function love.draw()
	love.graphics.draw(img[1].image,nil,nil,nil,nil,nil,img[1].ox,img[1].oy)
	psdShader.setShader(blendShader.clip)
	psdShader.drawClip(1,img[3].image,nil,nil,nil,nil,nil,img[3].ox,img[3].oy)
	psdShader.drawClip(2,img[4].image,nil,nil,nil,nil,nil,img[4].ox,img[4].oy)
	love.graphics.draw(img[2].image,nil,nil,nil,nil,nil,img[2].ox,img[2].oy)
	love.graphics.setShader()
end
```

### Blendmode sample
![](https://u.pomf.is/ntxeen.png)
```lua
local artal = require("artal")
local psdShader = require("psdShader")
love.graphics.setBackgroundColor(255,255,255)

img = artal.newPSD("sample.psd")

local blendShader = {}
blendShader.mul = love.graphics.newShader(psdShader.createShaderString("mul"))
blendShader.scrn = love.graphics.newShader(psdShader.createShaderString("scrn"))
blendShader.over = love.graphics.newShader(psdShader.createShaderString("over"))

local canvas = {} -- These blendmode all requires a swap canvas
canvas[1] = love.graphics.newCanvas(love.graphics.getDimensions())
canvas[2] = love.graphics.newCanvas(love.graphics.getDimensions())

function love.draw()

	love.graphics.setCanvas(canvas[1])
	love.graphics.clear(255,255,255)

	for i = 1, #img do
		if img[i].blend == "mul" or
			img[i].blend == "over" or
			img[i].blend == "scrn" then
			
			psdShader.setShader(blendShader[img[i].blend],canvas[1],canvas[2])
		end
		love.graphics.draw(img[i].image,nil,nil,nil,nil,nil,img[i].ox,img[i].oy)
		love.graphics.setShader()
	end
	
	-- Draw result to screen
	local preCanvas = love.graphics.getCanvas()
	love.graphics.setCanvas(nil)
	love.graphics.setBlendMode("alpha","premultiplied")
	love.graphics.draw(preCanvas)
	love.graphics.setBlendMode("alpha")
end
```
### Blend and Clipping
![](https://u.pomf.is/zjpidx.png)
```lua
local artal = require("artal")
local psdShader = require("psdShader")
love.graphics.setBackgroundColor(255,255,255)

img = artal.newPSD("sample.psd")

local blendShader = {}
blendShader.clipAndBlend = love.graphics.newShader(psdShader.createShaderString("mul", "over", "scrn"))

local canvas = {} -- These blendmode all requires a swap canvas
canvas[1] = love.graphics.newCanvas(love.graphics.getDimensions())
canvas[2] = love.graphics.newCanvas(love.graphics.getDimensions())

function love.draw()
	love.graphics.setCanvas(canvas[1])
	love.graphics.clear(255,255,255)

	love.graphics.draw(img[1].image,nil,nil,nil,nil,nil,img[1].ox,img[1].oy)
    psdShader.setShader(blendShader.clipAndBlend, canvas[1], canvas[2])
    psdShader.drawClip(1,img[3].image,nil,nil,nil,nil,nil,img[3].ox,img[3].oy)
    psdShader.drawClip(2,img[4].image,nil,nil,nil,nil,nil,img[4].ox,img[4].oy)
    love.graphics.draw(img[2].image,nil,nil,nil,nil,nil,img[2].ox,img[2].oy)
    love.graphics.setShader()
	
	-- Draw result to screen
	local preCanvas = love.graphics.getCanvas()
	love.graphics.setCanvas(nil)
	love.graphics.setBlendMode("alpha","premultiplied")
	love.graphics.draw(preCanvas)
	love.graphics.setBlendMode("alpha")
end
```

