local M = {}

local physics = require( "physics")

--print( "WALLS" )

--------- Start Create Wall variables------------

local wallSize = 5
local wallBounce = 0.2
local wallFriction = 0.3
local wallR = 0.6
local wallG = 0.6
local wallB = 0.8
local wallA = 0
local wallDesign = { wallR, wallG, wallB, wallA}
local wall_width, wall_height = display.contentWidth, display.contentHeight
--------- End Create Wall variables ------------

local function createWalls(  )
	--print( "WALLS WALLS WALLS" )

	local ground = display.newRect(0, 0, wall_width, wallSize);
	ground:setFillColor(wallDesign);
	ground.x = wall_width * 0.5;
	ground.y = wall_height ;
	ground.type = "border"
	
	local ceiling = display.newRect(0, 0, wall_width, wallSize);
	ceiling:setFillColor(wallDesign);
	ceiling.x = wall_width * 0.5;
	ceiling.y = 0;
	ceiling.type = "border"

	local left_wall = display.newRect(0, 0, wallSize, wall_height);
	left_wall:setFillColor(wallDesign);
	left_wall.x = 0;
	left_wall.y = wall_height * 0.5;
	left_wall.type = "border"
	
	local right_wall = display.newRect(0, 0, wallSize, wall_height);
	right_wall:setFillColor(wallDesign);
	right_wall.x = wall_width ;
	right_wall.y = wall_height * 0.5;
	right_wall.type = "border"

	physics.addBody(ground, "static", {friction = wallFriction, bounce = wallBounce});
    physics.addBody(ceiling, "static", {friction = wallFriction, bounce = wallBounce});
    physics.addBody(left_wall, "static", {friction = wallFriction, bounce = wallBounce});
    physics.addBody(right_wall, "static", {friction = wallFriction, bounce = wallBounce});

end
M.createWalls = createWalls

 
return M
