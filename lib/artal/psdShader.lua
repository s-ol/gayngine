--[[
The MIT License (MIT)

Copyright (c) 2016 Daniel Rasmussen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

local psdShader = {}
psdShader.version = "1.0"

local clampzeroSupport = love.graphics.getSupported().clampzero

local shaderString = {}
shaderString.define = [[
extern Image clipImage%i;
extern vec2 clipImage%iPos;
extern vec2 clipImage%isizeDifference;
extern vec2 clipImage%isize;

]]

shaderString.start =
[[
vec4 result;
extern Image canvas;
extern vec2 canvasSize;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
	vec4 imageTexel = Texel(texture, texture_coords) * color;
	vec4 screenTexel = Texel(canvas, screen_coords / canvasSize);

]]

function shaderString.texel(i)
	local result = string.format("\tvec4 clipImage%iTexel;\n",i)
	if not clampzeroSupport then -- Shader "clampzero" mode.
		result = result..string.format(
			"\tif((screen_coords.x - clipImage%iPos.x - clipImage%isize.x) * clipImage%isizeDifference.x < 1.0 &&\n"..
			"\t\t(screen_coords.x - clipImage%iPos.x) * clipImage%isizeDifference.x >= 0.0 &&\n"..
			"\t\t(screen_coords.y - clipImage%iPos.y - clipImage%isize.y) * clipImage%isizeDifference.y < 1.0 &&\n"..
			"\t\t(screen_coords.y - clipImage%iPos.y) * clipImage%isizeDifference.y >= 0.0)\n"..
			"\t"
			,i,i,i,i,i,i,i,i,i,i,i,i)
	end
	result = result..string.format("\tclipImage%iTexel = Texel(clipImage%i, ( (screen_coords - clipImage%iPos) * clipImage%isizeDifference ) / canvasSize );\n",i,i,i,i)
	return result
end

shaderString.middle = [[

	result = imageTexel;

]]

function shaderString.clipShaderFormula(i,blend)
	local result
	if blend == "norm" or blend == "pass" or blend == nil then
		result = string.format("\tresult = result * (1.0-clipImage%iTexel.a) + clipImage%iTexel * clipImage%iTexel.a;\n",i,i,i)
	elseif blend == "mul" then
		result = string.format("\tresult = result * (1.0 - clipImage%iTexel.a) + ( result * clipImage%iTexel ) * clipImage%iTexel.a;\n",i,i,i)

	elseif blend == "scrn" then
		result = string.format("\tresult = result * (1.0 - clipImage%iTexel.a) + ( 1.0 - (1.0-result) * (1.0-clipImage%iTexel) ) * clipImage%iTexel.a;\n",i,i,i)
	elseif blend == "over" then
		result = string.format(
			"\tfor ( int i = 0; i < 3; ++i )\n"..
			"\t{\n"..
			"\t\tresult[i] = result[i] * (1.0 - clipImage%iTexel.a) + ( (result[i] < 0.5) ?\n"..
			"\t\t\t2.0 * result[i] * clipImage%iTexel[i] :\n"..
			"\t\t\t1.0 - 2.0 * (1.0-result[i]) * (1.0-clipImage%iTexel[i]) ) * clipImage%iTexel.a;\n"..
			"\t}\n"
			,i,i,i,i)
	else
		assert(false, "Invaild blendmode type: "..blend)
	end

	return result
end

shaderString.mul = [[
	result = result * screenTexel;
]]

shaderString.scrn = [[
	result = 1.0 - (1.0-result) * (1.0-screenTexel);
]]

shaderString.over = [[
	for ( int i = 0; i < 3; ++i )
	{
		result[i] = (screenTexel[i] < 0.5) ?
			2.0*screenTexel[i] * result[i] :
			1.0-2.0*(1.0-screenTexel[i]) * (1.0-result[i]);
	}
]]

shaderString.finish = [[
	result.a = imageTexel.a;
	return result;
}
]]


function psdShader.createShaderString(mainBlendMode,...)
	local result = ""
	local clipLayerCount = select("#",...)

	for i = 1, clipLayerCount do
		assert(type(select(i,...)) == "string", "Vararg argument to psdShader.createShaderString must be a string.")
		result = result..string.format(shaderString.define,i,i,i,i)
	end

	result = result..shaderString.start

	for i = 1, clipLayerCount do
		result = result..shaderString.texel(i)
	end

	result = result..shaderString.middle

	for i = 1, clipLayerCount do
		result = result..shaderString.clipShaderFormula(i, select(i,...))
	end

	result = result.."\n"

	if mainBlendMode == "norm" or mainBlendMode == "pass" then
		-- Nothing
	elseif mainBlendMode == "mul" then
		result = result..shaderString.mul
	elseif mainBlendMode == "scrn" then
		result = result..shaderString.scrn
	elseif mainBlendMode == "over" then
		result = result..shaderString.over
	else
		assert(false, "Invaild blendmode passed to psdShader.createShaderString.")
	end

	result = result..shaderString.finish

	return result 
end

function psdShader.setShader(shader,swapCanvas1,swapCanvas2)
	local errorMessage = "psdShader.setShader: You must pass in a shader created with love.graphics.newShader(psdShader.createShaderString())"
	assert(type(shader) == "userdata", errorMessage)
	assert(shader:type() == "Shader", errorMessage)

	local canvas = love.graphics.getCanvas()
	local canvasWidth, canvasHeight
	if canvas == nil then
		canvasWidth, canvasHeight = love.graphics.getDimensions()
	else
		canvasWidth, canvasHeight = canvas:getDimensions()
	end
	

	if shader:getExternVariable("canvas") then
		assert(type(swapCanvas1) == "userdata" and
			swapCanvas1:type() == "Canvas",
			"psdShader: shader requires swapCanvas: argument 2 and 3.")
		assert(type(swapCanvas2) == "userdata" and
			swapCanvas2:type() == "Canvas",
			"psdShader: shader requires swapCanvas: argument 2 and 3.")

		if swapCanvas1 == canvas then
			love.graphics.setCanvas(swapCanvas2)
		else
			love.graphics.setCanvas(swapCanvas1)
		end
		love.graphics.clear()
		local preBlend = love.graphics.getBlendMode()
		love.graphics.setBlendMode("replace")
		love.graphics.draw(canvas)
		love.graphics.setBlendMode(preBlend)
		shader:send("canvas",canvas)
	end
	
	love.graphics.setShader(shader)
	

	if shader:getExternVariable("canvasSize") then
		shader:send("canvasSize",{canvasWidth,canvasHeight})
	end
end

-- Note that you can change any of the clipped image of a clipping layers anytime.
function psdShader.drawClip(drawOrderIndex,image,x,y,r,sx,sy,ox,oy,kx,ky)

	local canvas = love.graphics.getCanvas()
	local canvasWidth, canvasHeight
	if canvas == nil then
		canvasWidth, canvasHeight = love.graphics.getDimensions()
	else
		canvasWidth, canvasHeight = canvas:getDimensions()
	end
	local shader = love.graphics.getShader()

	x = x or 0
	y = y or 0
	r = r or 0
	sx = sx or 1
	sy = sy or sx
	ox = ox or 0
	oy = oy or 0
	kx = kx or 0
	ky = ky or 0

	assert(type(drawOrderIndex) == "number", "psdShader.drawClip: drawOrderIndex must be a number.")
	assert(image, "psdShader.drawClip: You must pass in a image.")
	assert(type(image) == "userdata", "psdShader.drawClip: You must pass in a image.")
	assert(image:type() == "Image", "psdShader.drawClip: You must pass in a image.")
	assert(r == 0, "psdShader.drawClip: Rotation for clipping layers not implemented.")
	assert(kx == 0, "psdShader.drawClip: Shearing for clipping layers not implemented.")
	assert(ky == 0, "psdShader.drawClip: Shearing for clipping layers not implemented.")

	assert(shader:getExternVariable("clipImage"..drawOrderIndex),
		"psdShader.drawClip: Shader does not have this index: "..drawOrderIndex)
	
	shader:send("clipImage"..drawOrderIndex,image)
	local sendScaleX = (canvasWidth / image:getWidth()) / sx
	local sendScaleY = (canvasHeight / image:getHeight()) / sy
	local sendX = x - ox * sx
	local sendY = y - oy * sy
	local sendSizeX = image:getWidth() * sx
	local sendSizeY = image:getHeight() * sy
	shader:send("clipImage"..drawOrderIndex.."Pos",{sendX, sendY})
	if shader:getExternVariable("clipImage"..drawOrderIndex.."size") then -- For the in shader "clampzero" mode
		shader:send("clipImage"..drawOrderIndex.."size",{sendSizeX, sendSizeY})
	end
	shader:send("clipImage"..drawOrderIndex.."sizeDifference",{sendScaleX, sendScaleY})
end

function psdShader.flatten(psdTableClippedTo,...)
	local canvas = love.graphics.newCanvas(psdTableClippedTo.image:getWidth(),psdTableClippedTo.image:getHeight())

	local psdClipTable = {...}

	love.graphics.setBlendMode("replace","premultiplied")
	love.graphics.setCanvas(canvas)
	love.graphics.clear(0,0,0,0)
	love.graphics.setColor(255,255,255)

	local blendList = {}
	for i = 1, #psdClipTable do
		blendList[i] = psdClipTable[i].blend
	end

	local stringClip = psdShader.createShaderString("norm",unpack(blendList))
	local clip = love.graphics.newShader(stringClip)

	psdShader.setShader(clip)

	for i = 1, #psdClipTable do

		psdShader.drawClip(
			i,
			psdClipTable[i].image,
			nil,
			nil,
			nil,
			nil,
			nil,
			psdClipTable[i].ox-psdTableClippedTo.ox,
			psdClipTable[i].oy-psdTableClippedTo.oy)
	end

	love.graphics.draw(psdTableClippedTo.image)

	love.graphics.setShader()
	love.graphics.setCanvas()
	love.graphics.setBlendMode("alpha")

	return canvas
end

return psdShader
