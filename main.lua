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

display.setStatusBar(display.HiddenStatusBar)
local vDS = shader.getVersion()
print( vDS  .. " . . . ml")

physics.start( )
physics.setGravity( 0, 0)

local movement, lighting = shader.getMovement()

local debugLevel = shader.setDebugLevel(0)

local cx, cy = display.contentCenterX, display.contentCenterY

local objectPhysics = true  -- set to false to turn off physics
local objectMotion  = true  -- turns on slight motion for physics objects
local objectList    = shader.getObjectList()    -- table of objects
--print( "#objectList start = " .. #objectList .. " main.lua" )

--shader.objectifier(objectPhysics) -- passes physics state references to the Dynamic Shader playground.  NOT NEEDED for new projects.




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
	name = "phish", -- optional 
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
local ploob = display.newImageRect( "art/ploob.png", 50, 46 )
ploob.x = cx + 90 ; ploob.y = cy - 90
ploob:toBack( )
-----------------------------------------------------------------------------------
-- shaderInfo table required for the Dynamic Shader 
ploob.shaderInfo = { 
	name = "ploob", -- optional 
	map1 = "art/ploob.png", 
	map2 = "art/ploob_n.png"
}
-- add object to the Dynamic Shader
shader.addObject(ploob) 
-----------------------------------------------------------------------------------
-- add physics
local ploob_image = "art/ploob.png"
local ploob_outline = graphics.newOutline( 2, ploob_image )
if (objectPhysics == true) then
	physics.addBody( ploob, { outline = ploob_outline} )
	ploob.size = 50 -- needed for movement.randoom
end
ploob:addEventListener("touch", move)


-----------------------------------------------------------------------------------
local ploob2 = display.newImageRect( "art/ploob.png", 50, 46 )
ploob2.x = cx - 105 ; ploob2.y = cy + 50
ploob2:toBack( )
-----------------------------------------------------------------------------------
-- shaderInfo table required for the Dynamic Shader 
ploob2.shaderInfo = { 
	name = "ploob2", -- optional 
	map1 = "art/ploob.png", 
	map2 = "art/ploob_n.png"
}
-- add object to the Dynamic Shader
shader.addObject(ploob2) 
-----------------------------------------------------------------------------------
-- add physics
--local ploob_image = "art/ploob.png"
--local ploob_outline = graphics.newOutline( 2, ploob_image )
if (objectPhysics == true) then
	physics.addBody( ploob2, { outline = ploob_outline} )
	ploob2.size = 50 -- needed for movement.randoom
end
ploob2:addEventListener("touch", move)
-----------------------------------------------------------------------------------
local goblinNumber = 150
local goblinNameNum = 1 -- start at 1
local distance = 160
local angle = 0
local delta = 12
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
				--local goblin = display.newImageRect("art/phish.png", 25, 31)
				local goblin = display.newImageRect("art/goblin.png", 20, 20)
				goblin.x = gobX ; goblin.y = gobY
				goblin:toBack( )
				------------------------------
				goblin.shaderInfo = {
					name = "goblin_shader " .. #objectList, -- optional 
					map1 = "art/goblin.png",  			   -- image file
					map2 = "art/goblin_n.png" 			   -- normal map file
					--name = "phish_shader " .. #objectList, -- optional 
					--map1 = "art/phish.png",  			   -- image file
					--map2 = "art/phish_n.png" 			   -- normal map file
				}
				shader.addObject(goblin)
				--print(goblin.shaderInfo.name .. " is objectList# " .. #objectList)
				------------------------------
				local goblin_image = "art/goblin.png"
				--local phish_outline = graphics.newOutline( 2, phish_image )
				local goblin_outline = graphics.newOutline( 2, goblin_image )
				if (objectPhysics == true) then
					physics.addBody( goblin, { outline = goblin_outline} )
					goblin.size = 20 -- needed for movement.randoom
				end
				goblin:addEventListener("touch", move)
			goblin.name = "goblin " .. goblinNameNum ; goblinNameNum = goblinNameNum + 1
			--local gobNum = display.newText( #objectList, gobX, gobY, "helvetica" , 7)
		end		
	end
end

----- Add the object to the Dynamic Shader -----
shader.addObject(phish)
phish:toBack( )
for i=1,goblinNumber do
	makeGoblins(i)
end

local function moveGoblin(  )
	if (#objectList > 0) then
		local n = math.random( #objectList )
		movement.random(objectList[n], 0.1, 0.1, 1, 1)
	end
end

if (objectPhysics == true and objectMotion == true) then
	timer.performWithDelay( 50, moveGoblin, 0)
end



----- START THE DYNAMIC SHADER -----
-----------------------------------------------------------------------------------
shader.start() -- start shading


