local M = {}

local physics = require("physics")
local shader  = require("plugin.dynamic_shader")

local objectList    = shader.getObjectList()
local debugLevel 	= shader.getDebugLevel()

--------- Start Create Wall variables------------

local wallSize = 5
local wallBounce = 0.2
local wallFriction = 0.3
local wallDesign = {0.6, 0.6, 0.8}
local wall_width, wall_height = display.contentWidth, display.contentHeight
local ground, ceiling, left_wall, right_wall
--------- End Create Wall variables ------------

local function protectWalls( e )
	local o = e.other
	if (o.shaderInfo) then
		shader.removeObject(o)
		display.remove( o )
		o = nil
	end
end

local function createWalls(  )

	ground = display.newRect(0, 0, wall_width, wallSize)
	ground:setFillColor(0.6, 0.6, 0.8)
	ground.x = wall_width * 0.5 ; ground.y = wall_height 
	--ground.alpha = 1
	
	ceiling = display.newRect(0, 0, wall_width, wallSize)
	ceiling:setFillColor(wallDesign);
	ceiling.x = wall_width * 0.5 ; ceiling.y = 0

	left_wall = display.newRect(0, 0, wallSize, wall_height)
	left_wall:setFillColor(wallDesign)
	left_wall.x = 0 ; left_wall.y = wall_height * 0.5
	
	right_wall = display.newRect(0, 0, wallSize, wall_height)
	right_wall:setFillColor(wallDesign)
	right_wall.x = wall_width ; right_wall.y = wall_height * 0.5

	physics.addBody(ground, "static", {friction = wallFriction, bounce = wallBounce});
    physics.addBody(ceiling, "static", {friction = wallFriction, bounce = wallBounce});
    physics.addBody(left_wall, "static", {friction = wallFriction, bounce = wallBounce});
    physics.addBody(right_wall, "static", {friction = wallFriction, bounce = wallBounce});

    ground:addEventListener( "collision", protectWalls )
    ceiling:addEventListener( "collision", protectWalls )
    left_wall:addEventListener( "collision", protectWalls )
    right_wall:addEventListener( "collision", protectWalls )

    timer.performWithDelay( 100, function() 
		ground:removeEventListener( "collision", protectWalls )
		ceiling:removeEventListener( "collision", protectWalls )
		left_wall:removeEventListener( "collision", protectWalls )
    	right_wall:removeEventListener( "collision", protectWalls )
	end )

end
M.createWalls = createWalls



 
return M
