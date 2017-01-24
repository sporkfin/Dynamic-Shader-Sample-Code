local M = {}
--[[
local shader         = require("plugin.dynamic_shader")
local momath        = require("plugin.dynamic_shader.momath")
local widget         = require("widget")
--]]

local shader        = require("plugin.dynamic_shader")
local widget        = require("widget")
local momath        = shader.getMomath()


local lt = shader.getLightTable() 
-- "Light Table" - references a snapshot of the properties effecting the light source object in the Dynamic Shader.
-- The properties are constantly in flux so shader.getLightTable() should be called everytime a reading of its properties is required

-- forward refernces for widgets, text (widget readout values 0 to 1) and labels (widget titles, e.g. "Alpha" or "Intensity")
local w_alpha, w_intensity, w_zValue, w_linear, w_constant, w_quadratic, w_lightType, 
      alpha_text, intensity_text, zValue_text, constant_text, linear_text, quadratic_text, lightType_text,
	  alpha_label, intensity_label, zValue_label, constant_label, linear_label, quadratic_label, lightType_label,

      w_reactiveIntensity, w_reactiveAlpha, w_reactiveZValue, w_reactiveRadius, w_lightRadius,
      reactiveIntensity_text, reactiveAlpha_text, reactiveZValue_text, reactiveRadius_text, lightRadius_text,
      reactiveIntensity_label, reactiveAlpha_label, reactiveZValue_label, reactiveRadius_label, lightRadius_label,

      w_pulseLight, pulseLight_label



  
-- responses for event listners
local function sliderListener( e )
    lt = shader.getLightTable()
	local id = e.target.id
	if (e.value) then
		local v = e.value * 0.01 
	 	if (id == "intensity") then
	 		shader.setIntensity(v)
	   		intensity_text.text = v
	    elseif (id == "alpha") then
	    	shader.setAlpha(v)
	    	alpha_text.text = v 
	    elseif (id == "zValue") then
	    	shader.setZValue(v)
	    	zValue_text.text = v
	    elseif (id == "constant") then
	    	shader.setConstant(v)
	    	constant_text.text = v
	    elseif (id == "linear") then
	    	shader.setLinear(v)
	    	linear_text.text = v
	    elseif (id == "quadratic") then
	    	shader.setQuadratic(v)
	    	quadratic_text.text = v
        elseif (id == "lightRadius") then
            local lightChange = v * lt.lightRadiusMax
            shader.setLightRadius(lightChange)
            lightRadius_text.text = lightChange
	   end
    elseif (id == "reactiveAlpha") then
        local b = w_reactiveAlpha.isOn
        shader.setReactiveAlpha(b)
    elseif (id == "reactiveIntensity") then
        local b = w_reactiveIntensity.isOn
        shader.setReactiveIntensity(b)
    elseif (id == "reactiveZValue") then
        local b = w_reactiveZValue.isOn
        shader.setReactiveZValue(b)
    elseif (id == "pulseLight") then
        local b = w_pulseLight.isOn
        shader.setLightPulse(b)
        if (b == false) then -- turn on widgets and reset values for alpha, intensity, zValue and lightType   
            shader.stopPulse()
            shader.cancelTransitions()
            local cA,  cI,   cZ = momath.round(lt.alpha,2), momath.round(lt.intensity,2), momath.round(lt.zValue,2)
            local cA1, cI1, cZ1 = cA*100, cI*100, cZ*100
            w_alpha.alpha     = 1     ; alpha_label.alpha     = 1  ; alpha_text.alpha     = 1 
            w_intensity.alpha = 1     ; intensity_label.alpha = 1  ; intensity_text.alpha = 1
            w_zValue.alpha    = 1     ; zValue_label.alpha    = 1  ; zValue_text.alpha    = 1
            w_lightType.alpha = 1     ; lightType_label.alpha = 1  ; lightType_text.alpha = 1
            w_alpha:setValue(cA1)     ; alpha_text.text       = cA ; --w_alpha.x = 45 ; w_alpha.y = 32
            w_intensity:setValue(cI1) ; intensity_text.text   = cI
            w_zValue:setValue(cZ1)    ; zValue_text.text     = cZ
            if (lightType_text.text == "1 point light") then -- if 1 point light is on, adjust alpha for factors
                w_constant.alpha  = 1  ; constant_label.alpha  = 1  ; constant_text.alpha  = 1
                w_linear.alpha    = 1  ; linear_label.alpha    = 1  ; linear_text.alpha    = 1
                w_quadratic.alpha = 1  ; quadratic_label.alpha = 1  ; quadratic_text.alpha = 1
            end
        elseif (b == true) then -- turn off widgets for alpha, intensity, zValue and lightType
            shader.startPulse()
            w_alpha.alpha     = 0     ; alpha_label.alpha     = 0  ; alpha_text.alpha     = 0 
            w_intensity.alpha = 0     ; intensity_label.alpha = 0  ; intensity_text.alpha = 0
            w_zValue.alpha    = 0     ; zValue_label.alpha    = 0  ; zValue_text.alpha    = 0
            w_lightType.alpha = 0     ; lightType_label.alpha = 0  ; lightType_text.alpha = 0
            w_constant.alpha  = 0     ; constant_label.alpha  = 0  ; constant_text.alpha  = 0
            w_linear.alpha    = 0     ; linear_label.alpha    = 0  ; linear_text.alpha    = 0
            w_quadratic.alpha = 0     ; quadratic_label.alpha = 0  ; quadratic_text.alpha = 0
        end 

    elseif (id == "reactiveRadius") then -- radius of the light
        local b = w_reactiveRadius.isOn
        shader.setReactiveRadius(b)
        if (b == true) then -- turn on sliders for light attenuation
            w_reactiveAlpha.alpha     = 1 ; reactiveAlpha_label.alpha     = 1 
            w_reactiveIntensity.alpha = 1 ; reactiveIntensity_label.alpha = 1 
            w_reactiveZValue.alpha    = 1 ; reactiveZValue_label.alpha    = 1 
            w_lightRadius.alpha       = 1 ; lightRadius_label.alpha       = 1 ; lightRadius_text.alpha = 1
        else
            w_reactiveAlpha.alpha     = 0 ; reactiveAlpha_label.alpha     = 0 
            w_reactiveIntensity.alpha = 0 ; reactiveIntensity_label.alpha = 0 
            w_reactiveZValue.alpha    = 0 ; reactiveZValue_label.alpha    = 0 
            w_lightRadius.alpha       = 0 ; lightRadius_label.alpha       = 0 ; lightRadius_text.alpha = 0
        end
	elseif (id == "lightType") then

		local effect, name = shader.switchLightType() 
        -- returns effect - "composite.normalMapWith1DirLight" or "composite.normalMapWith1PointLight"
        -- returns name - "directional light" or "1 point light"

	   	lightType_text.text = name -- change widget switch text to "directional light" or "1 point light"

	   	if (effect == "composite.normalMapWith1PointLight") then -- turn on sliders for light attenuation
	   		w_constant.alpha  = 1 ; constant_label.alpha  = 1 ; constant_text.alpha  = 1
            w_linear.alpha    = 1 ; linear_label.alpha    = 1 ; linear_text.alpha    = 1
	   		w_quadratic.alpha = 1 ; quadratic_label.alpha = 1 ; quadratic_text.alpha = 1
	   	else
            w_constant.alpha  = 0 ; constant_label.alpha  = 0 ; constant_text.alpha  = 0
	   		w_linear.alpha    = 0 ; linear_label.alpha    = 0 ; linear_text.alpha    = 0
            w_quadratic.alpha = 0 ; quadratic_label.alpha = 0 ; quadratic_text.alpha = 0
	   	end
	end
end

local wL, wT, right, bottom = 10, 10, display.actualContentWidth, display.actualContentHeight -- widget left, widget top, right, bottom

w_alpha = widget.newSlider
{	
	id = "alpha",
    top = wT,
    left = wL,
    width = 50,
    height = 400,
    value = 0,
    listener = sliderListener
}
w_alpha:setValue(lt.alpha * 100)
alpha_label = display.newText("Alpha", 102, 31, 'Helvetica', 7); alpha_label.align = "center"
alpha_label:setFillColor( 0.7, 0.3, 0.7 )
alpha_text = display.newText("Alpha", 102, 41, 'Helvetica', 9);
alpha_text.text = w_alpha.value * 0.01 
w_alpha.alpha = 0 ; alpha_label.alpha = 0 ; alpha_text.alpha = 0


w_intensity = widget.newSlider
{	
	id = "intensity",
    top = wT + 30,
    left = wL,
    width = 50,
    height = 400,
    value = 0,
    listener = sliderListener
}
w_intensity:setValue(lt.intensity * 100)
intensity_label = display.newText("Intensity", 102, 61, 'Helvetica', 7);
intensity_label:setFillColor( 0.7, 0.3, 0.7 )
intensity_text = display.newText("Intensity", 102, 71, 'Helvetica', 9);
intensity_text.text = w_intensity.value * 0.01 
w_intensity.alpha = 0 ; intensity_label.alpha = 0 ; intensity_text.alpha = 0


w_zValue = widget.newSlider
{	
	id = "zValue",
    top = wT + 60,
    left = wL,
    width = 50,
    height = 400,
    value = 0,
    listener = sliderListener
}
w_zValue:setValue(lt.zValue * 100)
zValue_label = display.newText("zValue", 102, 91, 'Helvetica', 7);
zValue_label:setFillColor( 0.7, 0.3, 0.7 )
zValue_text = display.newText("zVal", 102, 99, 'Helvetica', 9);
zValue_text.text = w_zValue.value * 0.01 
w_zValue.alpha = 0 ; zValue_label.alpha = 0 ; zValue_text.alpha = 0

----- widget switch to change light type (directional or 1 point light) -----
w_lightType = widget.newSwitch(
    {
    	name = "lightType",
        left = wL,
        top = wT + 100,
        style = "onOff",
        id = "lightType",
        initialSwitchState = lt.lightType,
        onPress = sliderListener
    }
)
lightType_label = display.newText("Light Type", 102, 121, 'Helvetica', 7);
lightType_label:setFillColor( 0.3, 0.4, 0 )
lightType_text  = display.newText("lightType", 102, 129, 'Helvetica', 7);
lightType_text.text = lt.effectName
w_lightType.alpha = 0 ; lightType_label.alpha = 0 ; lightType_text.alpha = 0

----- widget sliders for 1 point light attenuation values -----
w_constant = widget.newSlider
{   
    id = "constant",
    top = wT + 130,
    left = wL,
    width = 50,
    height = 400,
    value = 50,
    listener = sliderListener
}
w_constant.alpha = 0 ; w_constant:setValue(lt.constant * 100)
constant_label = display.newText("constant", 102, 161, 'Helvetica', 7);
constant_label.alpha = 0 ; constant_label:setFillColor( 0.7, 0.3, 0.7 )
constant_text = display.newText("constant", 102, 169, 'Helvetica', 9);
constant_text.alpha = 0
constant_text.text = w_constant.value * 0.01 


w_linear = widget.newSlider
{	
	id = "linear",
    top = wT + 160,
    left = wL,
    width = 50,
    height = 400,
    value = 50,
    listener = sliderListener
}
w_linear.alpha = 0 ; w_linear:setValue(lt.linear * 100) 
linear_label = display.newText("linear", 102, 191, 'Helvetica', 7);
linear_label.alpha = 0 ; linear_label:setFillColor( 0.7, 0.3, 0.7 )
linear_text = display.newText("linear", 102, 199, 'Helvetica', 9);
linear_text.alpha = 0
linear_text.text = w_zValue.value * 0.01 


w_quadratic = widget.newSlider
{	
	id = "quadratic",
    top = wT + 190,
    left = wL,
    width = 50,
    height = 400,
    value = 50,
    listener = sliderListener
}
w_quadratic.alpha = 0 ; w_quadratic:setValue(lt.quadratic * 100)
quadratic_label = display.newText("quadratic", 102, 221, 'Helvetica', 7);
quadratic_label.alpha = 0 ; quadratic_label:setFillColor( 0.7, 0.3, 0.7 )
quadratic_text = display.newText("quadratic", 102, 229, 'Helvetica', 9);
quadratic_text.alpha = 0
quadratic_text.text = w_quadratic.value * 0.01 






w_reactiveRadius = widget.newSwitch(
    {
        name = "reactiveRadius",
        left = wL,
        top = bottom - 40,
        style = "onOff",
        id = "reactiveRadius",
        initialSwitchState = lt.reactiveRadius,
        onRelease = sliderListener
    }
)
reactiveRadius_label = display.newText("Reactive \nRadius", 30, bottom - 50,  'Helvetica', 8);
reactiveRadius_label:setFillColor( 0.1, 0.9, 0.6 )

w_reactiveIntensity = widget.newSwitch(
    {
        name = "reactiveIntensity",
        left = wL + 60,
        top = bottom - 40,
        style = "checkbox",
        id = "reactiveIntensity",
        initialSwitchState = lt.reactiveIntensity,
        onRelease = sliderListener
    }
)
reactiveIntensity_label = display.newText("Reactive \nIntensity", 90, bottom - 50,  'Helvetica', 8);
reactiveIntensity_label:setFillColor( 0.1, 0.6, 0.8 )


w_reactiveAlpha = widget.newSwitch(
    {
        name = "reactiveAlpha",
        left = wL + 100,
        top = bottom - 40,
        style = "checkbox",
        id = "reactiveAlpha",
        initialSwitchState = lt.reactiveAlpha,
        onRelease = sliderListener
    }
)
reactiveAlpha_label = display.newText("Reactive \nAlpha", 130, bottom - 50,  'Helvetica', 8);
reactiveAlpha_label:setFillColor( 0.1, 0.6, 0.8 )


w_reactiveZValue = widget.newSwitch(
    {
        name = "reactiveZValue",
        left = wL + 140,
        top = bottom - 40,
        style = "checkbox",
        id = "reactiveZValue",
        initialSwitchState = lt.reactiveZValue,
        onRelease = sliderListener
    }
)
reactiveZValue_label = display.newText("Reactive \nZValue", 170, bottom - 50,  'Helvetica', 8);
reactiveZValue_label:setFillColor( 0.1, 0.6, 0.8 )


local slideStart = lt.lightRadius / lt.lightRadiusMax * 100
w_lightRadius = widget.newSlider
{   
    id = "lightRadius",
    top = bottom - 44,
    left = wL + 185,
    width = 50,
    height = 400,
    value = slideStart,
    listener = sliderListener
}
w_lightRadius.alpha = 1 ; w_lightRadius:setValue(slideStart) --lt.lightRadius / lt.lightRadiusMax * 100 print( "lt val = ".. w_lightRadius.value )
lightRadius_label = display.newText("Light Radius", 220, bottom - 55, 'Helvetica', 8);
lightRadius_label.alpha = 1 ; lightRadius_label:setFillColor(  0.1, 0.6, 0.8 )
lightRadius_text = display.newText("quadratic", 220, bottom - 47, 'Helvetica', 9);
lightRadius_text.alpha = 1 ; lightRadius_text:setFillColor(  0.1, 0.6, 0.8 )
lightRadius_text.text =  lt.lightRadius

local function adjustWidgets(  )
   -- w_alpha.value     = lt.value * 100  
   w_alpha:setValue( lt.alpha * 100 )
    w_intensity.calue = lt.intensity * 100
end
  
w_pulseLight = widget.newSwitch(
    {
        name = "pulseLight",
        left = right - 46,
        top = bottom - 40,
        style = "checkbox",
        id = "pulseLight",
        initialSwitchState = lt.pulseLight,
        onRelease = sliderListener
        --onPress = sliderListener
    }
)
pulseLight_label = display.newText("Pulse Light", right - 30, bottom - 45,  'Helvetica', 8);
pulseLight_label:setFillColor( 0.1, 0.6, 0.8 )

shader.startPulse() -- start pulsing the light



return M