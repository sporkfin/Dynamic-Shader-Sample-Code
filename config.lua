

if string.sub(system.getInfo("model"),1,4) == "iPad" then
    application = 
    {
        content =
        {
            width = 360,
            height = 480,
            scale = "letterBox",
            xAlign = "center",
            yAlign = "center",
            fps = 30,
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            }
        }
    }

elseif string.sub(system.getInfo("model"),1,2) == "iP" and display.pixelHeight > 960 then
    application = 
    {
        content =
        {
            width = 320,
            height = 568,
            scale = "letterBox",
            xAlign = "center",
            yAlign = "center",
            fps = 30,
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            }
        }
    }

elseif string.sub(system.getInfo("model"),1,2) == "iP" then
    application = 
    {
        content =
        {
            width = 320,
            height = 480,
            scale = "letterBox",
            xAlign = "center",
            yAlign = "center",
            fps = 30,
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            }
        }
    }
elseif display.pixelHeight / display.pixelWidth > 1.72 then
    application = 
    {
        content =
        {
            width = 320,
            height = 570,
            scale = "letterBox",
            xAlign = "center",
            yAlign = "center",
            fps = 30,
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
    }
else
    --[[
    local aspectRatio = display.pixelHeight / display.pixelWidth
    application = {
       content = {
          width = aspectRatio > 1.5 and 800 or math.floor( 1200 / aspectRatio ),
          height = aspectRatio < 1.5 and 1200 or math.floor( 800 * aspectRatio ),
          scale = "letterBox",
          fps = 30,
     
          imageSuffix = {
             ["@2x"] = 1.3,
          },
       },
    }
    --]]
    ---[[
    application = 
    {
        content =
        {
            width = 320,
            height = 512,
            scale = "letterBox",
            xAlign = "center",
            yAlign = "center",
            fps = 30,
            imageSuffix = 
            {
                ["@2x"] = 1.5,
                ["@4x"] = 3.0,
            },
        },
        notification = 
        {
            iphone = {
                types = {
                    "badge", "sound", "alert"
                }
            }
        }
    }
    --]]
end


