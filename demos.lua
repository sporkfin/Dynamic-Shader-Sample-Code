local M = {}

local shader 		= require("plugin.dynamic_shader")
local widget        = require("widget")

local objectList    = shader.getObjectListStart()    -- table of objects
local methodTest
local textBack = display.newRect( display.contentCenterX, 0, display.contentWidth, 100 ) ; textBack.alpha = 0
local goDemo = true

local function startDemo( e )
	if (goDemo == true) then
		goDemo = false
		methodTest()
	end
end


local w_demo = widget.newSwitch(
    {
        name = "demoBut",
        left = display.contentWidth - 46,
        top = 16,
        style = "checkbox",
        id = "demoBut",
        initialSwitchState = false,
        onRelease = startDemo
        --onPress = sliderListener
    }
)
local demo_label = display.newText("Start Demo", display.contentWidth - 30, 10,  'Helvetica', 8);
demo_label:setFillColor( 0.1, 0.6, 0.8 )

------------------ Method Tests --------------
function methodTest(  )

	transition.to( w_demo, {delay = 500, time = 1500, alpha = 0, onComplete = function()
		--w_demo:setState(false) 
		end} )
	transition.to( demo_label, {delay = 500, time = 1500, alpha = 0} )
	
	textBack:setFillColor( 0, 0, 0 ) ; textBack.alpha = 0.85
	local delayTime, timeTime, totalTime, alphaStart, alphaEnd = 4000, 2000, 7000, 0.8, 0
	local methodText = display.newText("Dynamic Shader Method Test", display.contentCenterX, 16, 'Helvetica', 12) ; --methodText.alpha = alphaStart
	transition.to( methodText, {delay = delayTime, time = timeTime, alpha = alphaEnd} )
	methodText:setFillColor( 0.1, 0.6, 0.8 )
	local reshade = {}
	local reshadeInfo = {}
	local restarter = {}
	local restarterInfo = {}
	timer.performWithDelay( totalTime, function() 
			methodText.alpha = alphaStart
			methodText.text = "shader.removeObject() - remove objects from Dynamic Shader\nshader.stop() - stopping the Dynamic Shader"
			transition.to( methodText, {delay = delayTime, time = timeTime, alpha = alphaEnd} )
	        for i=1,30 do
	        	if (objectList[i] and objectList[i].shaderInfo) then
	        		reshade[#reshade+1] = objectList[i]
	        		reshadeInfo[#reshadeInfo+1] = {
	        			objectList[i].shaderInfo.map1, -- save the image file reference
	        			objectList[i].shaderInfo.map2  -- save the normal map file reference
	        		}
	        		shader.removeObject(objectList[i])
	        	end
	        end
	        shader.stop()
		end )

	timer.performWithDelay( totalTime * 2, function() 
			methodText.alpha = alphaStart
			methodText.text = "return objects to the Dynamic Shader\nshader.start() - restart the Dynamic Shader"
			transition.to( methodText, {delay = delayTime, time = timeTime, alpha = alphaEnd} )
	        for i=1,#reshade do
	        	reshade[i].shaderInfo = {
	        		map1 = reshadeInfo[i][1], -- reinstate image file from reshadeInfo table
	        		map2 = reshadeInfo[i][2]  -- reinstate normal map file from reshadeInfo table
	        	}
	        	shader.addObject(reshade[i])
	        end
	        shader.start()
		end )


	timer.performWithDelay( totalTime * 3, function() 
			methodText.alpha = alphaStart 
			methodText.text = "shader.destroy() - removes all objects from Dynamic Shader and calls shader.stop()"
			transition.to( methodText, {delay = delayTime, time = timeTime, alpha = alphaEnd} )
	        for i=1,#objectList do
	        	restarter[#restarter+1] = objectList[i]
	        	restarterInfo[#restarterInfo+1] = {
	        		objectList[i].shaderInfo.map1, -- save the image file reference
	        		objectList[i].shaderInfo.map2  -- save the normal map file reference
	        	}
	        end
	        --print( "objectList = " .. #objectList .. " / restarter List = " .. #restarter .. " - main.lua" )
	        shader.destroy()
		end )

	timer.performWithDelay( totalTime * 4, function() 
			methodText.alpha = alphaStart 
			methodText.text = "returning all objects to the Dynamic Shader\nshader.start() restart the Dynamic Shader"
			transition.to( methodText, {delay = delayTime, time = timeTime, alpha = alphaEnd} )
			--print( "objectList = " .. #objectList .. " / restarter List = " .. #restarter .. " - main.lua")
	        for i=1,#restarter do
	        	restarter[i].shaderInfo = {
	        		map1 = restarterInfo[i][1], -- reinstate image file from restarterInfo table
	        		map2 = restarterInfo[i][2]  -- reinstate normal map file from restarterInfo table
	        	}
	        	shader.addObject(restarter[i])
	        end
	        shader.start()
		end )

	timer.performWithDelay( totalTime * 4 + 1000, function() 
			transition.to( textBack, {delay = delayTime, time = timeTime, alpha = alphaEnd, onComplete = function()
				transition.to( w_demo, {time = 1500, alpha = 1; onComplete = function()
						goDemo = true
					end} )
				transition.to( demo_label, {time = 1500, alpha = 1} )
				end} )
		end )
end


return M