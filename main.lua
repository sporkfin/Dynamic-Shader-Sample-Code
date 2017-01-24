-- 
-- Dynamic Shader plug-in for Corona SDK http://www.coronalabs.com
-- Sample Code
-- 
-- All artwork associated with this sample code is for test purposes only
-- Copyright (C) 2017 SporkFin Software. All Rights Reserved.
--
------------------------------------------------------------

-- Load plugin library

local physics 			= require("physics")
local shader 			= require("plugin.dynamic_shader")
local math 				= require("math")
local controls 			= require("controls")
local walls 			= require("walls")
local demos 			= require("demos")

local vDS = shader.getVersion()
print( vDS  .. " . . . ml")

physics.start( )
physics.setGravity( 0, 0)

local movement, lighting = shader.getMovement()


display.setStatusBar(display.HiddenStatusBar)
local debugLevel = shader.setDebugLevel(2)

if (debugLevel > 0) then
	print( "debugLevel set to " .. debugLevel )
end
local cx, cy = display.contentCenterX, display.contentCenterY

local objectPhysics = true  -- set to false to turn off physics
local objectMotion  = true  -- turns on slight motion for physics objects
local objectList    = shader.getObjectListStart()    -- table of objects
print( "#objectList start = " .. #objectList .. " main.lua" )

shader.objectifier(objectPhysics) -- passes physics state references to the Dynamic Shader playground.  NOT NEEDED for new projects.




 -- create physics boundaries
walls.createWalls()

-- function for dragging objects
local function move( e )
	local o = e.target
	if (objectPhysics == true) then
		movement.move(e)
	else
		lighting.move(e)
	end	
end

							----- ADD LIGHT SOURCE -----
-----------------------------------------------------------------------------------
----- Define the light source -----
local light = display.newImageRect( "art/light.png", 50, 50 ) 
light.x = cx ; light.y = cy
light:setFillColor( 1, 1, 1) -- this is the default color
-----------------------------------------------------------------------------------
----- Add the light source to the Dynamic Shader -----
shader.addLight(light)
-----------------------------------------------------------------------------------
----- Add touch-controlled movement for the light -----
light:addEventListener( "touch", move )
-----------------------------------------------------------------------------------
----- add physics properites to the light if necessary -----
if (objectPhysics == true) then
	physics.addBody( light, {radius = 22} )
end
-----------------------------------------------------------------------------------



					   ----- ADD AN OBJECT -----
-----------------------------------------------------------------------------------
----- define the object -----
local phish = display.newImageRect( "art/phish.png", 50, 62)
phish.x = cx + 120 ; phish.y = cy - 40 ; phish.name = "phish"
-----------------------------------------------------------------------------------
----- add the shaderInfo table to the object -----
phish.shaderInfo = {
	name = "phish_shader", -- optional 
	map1 = "art/phish.png",  -- image file
	map2 = "art/phish_n.png" -- normal map file
}
----- Add the object to the Dynamic Shader -----
shader.addObject(phish)
phish:toBack( )
-----------------------------------------------------------------------------------
----- add physics properites to the object if necessary -----
local phish_image = "art/phish.png"
local phish_outline = graphics.newOutline( 2, phish_image )
if (objectPhysics == true) then
	physics.addBody( phish, { outline = phish_outline} )
	phish.size = 50 -- needed for movement.randoom
end
----- Add touch-controlled movement -----
phish:addEventListener("touch", move)
-----------------------------------------------------------------------------------
----- Add object to the list of objects -----
--objectList[#objectList+1] = phish


						----- More Objects Loaded remotely -----
-----------------------------------------------------------------------------------
--local pug = shader.loadCritter("pug") ; pug.name = "pug"  -- object loaded and added to the Dynamic Shader remotely
--local ploob = shader.loadCritter("ploob") ; ploob.name = "ploob" -- object loaded and added to the Dynamic Shader remotely
-----------------------------------------------------------------------------------
print( "#objectList = " .. #objectList .. " main.lua" )


					 ----- More Objects Loaded remotely -----
-----------------------------------------------------------------------------------
local goblinNumber = 100
local goblinNameNum = 1 -- start at 1
local distance = 160
local angle = 0
local delta = 10
local spacing = 20
local varXY = 8

local function makeGoblins( i ) -- make a bunch of goblins
	if (goblinNumber > 0) then
		--local goblin
		local varDistX = math.random( varXY ) ; local dirX = math.random() ; if dirX == 1 then varDistX = varDistX * -1 end
		local varDistY = math.random( varXY ) ; local dirY = math.random() ; if dirY == 1 then varDistY = varDistY * -1 end
		local xVal = math.cos( math.rad(angle) )
		local yVal = math.sin( math.rad(angle) )
		local gobX = xVal * distance + cx + varDistX
		local gobY = yVal * distance + cy + varDistY
		angle = angle + delta
		if angle > 360 then angle = angle - 360 ; distance = distance - spacing end
		if (xVal > 0 and yVal > 0 or xVal < 0 and yVal < 0) then
			local goblin = shader.loadCritter("goblin", gobX, gobY) -- object loaded and added to the Dynamic Shader remotely
			goblin.name = "goblin " .. goblinNameNum ; goblinNameNum = goblinNameNum + 1
			local gobNum = display.newText( #objectList, gobX, gobY, "helvetica" , 7)
		end		
	end
end
for i=1,goblinNumber * 1.5 do
	makeGoblins(i)
end

local function moveGoblin(  )
	if (#objectList > 0) then
		local n = math.random( #objectList )
		movement.random(objectList[n], 0.1, 0.1, 1, 1)
	end
end

if (objectPhysics == true and objectMotion == true) then
	timer.performWithDelay( 100, moveGoblin, 0)
end



----- START THE DYNAMIC SHADER -----
-----------------------------------------------------------------------------------
shader.start() -- start shading


