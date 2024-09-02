function love.load()
    --Sets the winsow to full screen
    love.window.setFullscreen(true, "desktop")

    AppState = 'HomePage'
    love.graphics.setDefaultFilter('linear', 'linear')
    SettingsCog = love.graphics.newImage("Images/1x/SetCog.png")
    PlayButton = love.graphics.newImage("Images/1x/PlayButton.png")
    Microphone = love.graphics.newImage("Images/1x/MicroPhone.png")
    ArrowButton = love.graphics.newImage("Images/1x/ArrowButton.png")
    ButtonStateCog = 'off'
    ButtonStatePlay = 'off'
    ButtonStateMainT = 'off'
    ButtonStateMic = 'on'
    ButtonStateArr = 'off'
    PlayX  = 0
    PlayXS = 0
    PlayY = 0
    PlayYS = 0
    TextActivated = false
    Text = ''
    WrappedText = ''
    CharLimit = 2200  
    utf8 = require("utf8")
    TextSpeed = 3
    text = " "
    love.keyboard.setKeyRepeat(true)
end


function love.textinput(t)
    if #text < CharLimit then
        text = text .. t
    end
end

function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)

        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            text = string.sub(text, 1, byteoffset - 1)
        end
    end

    if love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl") then
        if key == "v" then
            local clipboardText = love.system.getClipboardText()
            if clipboardText and #text < CharLimit then
                text = text..clipboardText
                print("Pasted text: " .. clipboardText)
            end
        end
    end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
    end
end


function love.mousepressed()
    if MouseX > 2109 and MouseX < 2257 and MouseY > 146 and MouseY < 296 and love.mouse.isDown(1) == true then
        if ButtonStateCog == 'off' then
        AppState = 'Settings'
        ButtonStateCog = 'on'
        love.graphics.setColor(1, 0, 0)
        else
        AppState = 'HomePage'
        ButtonStateCog = 'off'
        love.graphics.setColor(0, 1, 0)
        end
    end
    if AppState == 'HomePage' then
        PlayX = 300
        PlayXS = 449
        PlayY = 146
        PlayYS = 296

        if MouseX > PlayX and MouseX < PlayXS and MouseY > 146 and MouseY < PlayYS and love.mouse.isDown(1) == true then
            if ButtonStatePlay == 'off' then
                ButtonStatePlay = 'on'
                AppState = 'Reading'
                else
                ButtonStatePlay = 'off'
            end
        end

        if MouseX > 293 and MouseX < 2264 and MouseY > 627 and MouseY < 1312 and love.mouse.isDown(1) == true then
            if ButtonStateMainT == 'off' then
                ButtonStateMainT = 'on'
                TextActivated = true
                else
                ButtonStateMainT = 'off'
                TextActivated = false
            end
        end
        PlayX = 1108
        PlayXS = 1483
        PlayY = 591
        PlayYS = 964
    end

    if MouseX > 832 and MouseX < 1132 and MouseY > 564 and MouseY < 969 and love.mouse.isDown(1) == true then
        if ButtonStateMic == 'off' then
            ButtonStateMic = 'on'
            TextSpeed = 3
            ButtonStateArr = 'off'
        end
    end

    if MouseX > 1432 and MouseX < 1732 and MouseY > 564 and MouseY < 969 and love.mouse.isDown(1) == true then
        ButtonStateArr = 'on'
        ButtonStateMic = 'off'
    end

    if ButtonStatePlay == 'on' then
        if MouseX > PlayX and MouseX < PlayXS and MouseY > PlayY and MouseY < PlayYS and love.mouse.isDown(1) == true then
            if ButtonStatePlay == 'off' then
                AppState = 'Reading'
                ButtonStatePlay = 'on'
                love.graphics.setColor(1, 0, 0)
                else
                AppState = 'HomePage'
                ButtonStatePlay = 'off'
                love.graphics.setColor(0, 1, 0)
            end
        end
    end
    if ButtonStateArr == 'on' then
        if MouseX > 1373 and MouseX < 1449 and MouseY > 1006 and MouseY < 1083 and love.mouse.isDown(1) == true and TextSpeed <99 then
            TextSpeed = TextSpeed + 1
        end
    end

    if ButtonStateArr == 'on' then
        if MouseX > 1113 and MouseX < 1187 and MouseY > 1006 and MouseY < 1083 and love.mouse.isDown(1) == true and TextSpeed > 0 then
            TextSpeed = TextSpeed - 1
        end
    end
end

function love.update(dt)
    love.keyboard.setTextInput( TextActivated, 304, 608, 1900, 680 )
    MouseX = love.mouse.getX()
    MouseY = love.mouse.getY()

    love.graphics.print(love.mouse.getX()..' '..love.mouse.getY(), 1000, 400, 0, 1)
    
end
--Where the screen gets rendered
function love.draw()
    local cRecx = 1000
    local cRecy = 200
    local cRecOy = 500
--A bunch of code for the centered text that says "TELEPROMTER"
    local cText = 'TELEPROMPTER'
    local font = love.graphics.newFont(100)
    love.graphics.setFont(font)
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()
    local textWidth = font:getWidth(cText)
    local textHeight = font:getHeight(cText)
    local x = (screenWidth - textWidth)/2
    local y = (screenHeight - textHeight)/2
    --Here is where we check the state of the app and what it draws accordingly
    if AppState == 'HomePage' then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setLineWidth( 10 )
        love.graphics.rectangle('line', love.graphics:getWidth()/2-cRecx/2, love.graphics:getHeight()/2-cRecy/2-cRecOy, cRecx, cRecy, 20, 20, 20)
        love.graphics.print(cText, x, y - 500)
        love.graphics.draw(SettingsCog, 1200, -350, 0, 1)
        love.graphics.draw(PlayButton, 675-(love.graphics:getWidth()/2), -350+22, 0, 1)
        love.graphics.rectangle('line', love.graphics:getWidth()/2-2000/2, love.graphics:getHeight()/2+800/2-500, 2000, 700, 20, 20, 20)

        if TextActivated == false then
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.print('Input Text Here...', 301, 643, nil, 0.3 )
        else
            love.graphics.printf(text, 304, 643, 6270, 'left', 0, 0.3)
        end
    elseif AppState == 'Settings' then
        love.graphics.setColor(1, 1, 1)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font, 15)
        love.graphics.printf('TEXT ADVANCEMENT MODES', (love.graphics:getWidth()/2)-(font:getWidth( 'TEXT ADVANCEMENT MODES' )/2), 300, 2000, 'left')
        if ButtonStateArr == 'on' then
            love.graphics.setColor(0, 1, 0)
            love.graphics.draw(ArrowButton, -338, -368, 0, 2)
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(Microphone, -938, -368, 0, 2)
            love.graphics.rectangle('line', love.graphics:getWidth()/2-75, love.graphics:getHeight()/2+250, 150, 150, 20, 20, 20)
            love.graphics.print(TextSpeed,love.graphics:getWidth()/2-(font:getWidth(TextSpeed)/2), love.graphics:getHeight()/2+250+(font:getHeight(TextSpeed)/4)-10 )
            love.graphics.draw(PlayButton, love.graphics:getWidth()/2-360, love.graphics:getHeight()/2+600, 0, 0.5, -0.5)
            love.graphics.draw(PlayButton, love.graphics:getWidth()/2+360, love.graphics:getHeight()/2+50, 0, -0.5, 0.5)
        elseif ButtonStateMic == 'on' then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(ArrowButton, -338, -368, 0, 2)
            love.graphics.setColor(0, 1, 0)
            love.graphics.draw(Microphone, -938, -368, 0, 2)
        else
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(Microphone, -938, -368, 0, 2)
            love.graphics.draw(ArrowButton, -338, -368, 0, 2)
        end
        if ButtonStateCog == 'off' then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(SettingsCog, 1200, -350, 0, 1)
            love.graphics.draw(PlayButton, 1200-(love.graphics:getWidth()/2), 0100, 0, 1)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.draw(SettingsCog, 1200, -350, 0, 1)
        end
    elseif AppState == 'Reading' then
        if ButtonStatePlay == 'off' then
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(PlayButton, 675-(love.graphics:getWidth()/2), -350, 0, 1)
        else
            love.graphics.setColor(1, 0, 0)
            love.graphics.draw(PlayButton, 125-(love.graphics:getWidth()/2), -600, 0, 2.5)
            love.graphics.setFont(font, 20)
            love.graphics.printf('STOP', (love.graphics:getWidth()/2)-(font:getWidth( 'STOP' )/2), 370, 2000, 'left')
        end
    end
    --love.graphics.print(love.mouse.getX()..' '..love.mouse.getY(), 1000, 400, 0, 1)
end

-- Temp