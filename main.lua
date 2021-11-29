WIDTH = 1500
HEIGHT = 1000

VWIDTH = 300
VHEIGHT = 200

PSPEED = 200

BAR_WIDTH = 5
BAR_HEIGHT = 20
PADDING = 10

local push = require "push"

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())

    sFont = love.graphics.newFont("font.ttf", 8)
    lFont = love.graphics.newFont("font.ttf", 24)
    love.graphics.setFont(sFont)

    push:setupScreen(VWIDTH, VHEIGHT, WIDTH, HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true,
    })

    p1Score = 0
    p2Score = 0

    bX = VWIDTH / 2 - 2
    bY = VHEIGHT / 2 - 2

    bdX = math.random(2) == 1 and 100 or -100
    bdY = math.random(-50, 50)

    p1Y = 20
    p2Y = VHEIGHT - 40

    state = "start"
end

function love.keypressed(key, scancode, isrepeat)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if state == "start" then
            state = "play"
        else
            -- reupdate game to new starting position
            state = "start"

            bX = VWIDTH / 2 - 2
            bY = VWIDTH / 2 - 2
            bdX = math.random(2) == 1 and 100 or -100
            bdY = math.random(-50, 50)
        end
    end
end

function love.update(dt)
    -- p1 movement
    if love.keyboard.isDown("s") then
        p1Y = math.min(VHEIGHT - 20, p1Y + (PSPEED * dt))
    elseif love.keyboard.isDown("d") then
        p1Y = math.max(0, p1Y - (PSPEED * dt))
    end

    -- p2 movement
    if love.keyboard.isDown("j") then
        p2Y = math.min(VHEIGHT - 20, p2Y + (PSPEED * dt))
    elseif love.keyboard.isDown("k") then
        p2Y = math.max(0, p2Y - (PSPEED * dt))
    end

    if state == "play" then
        bX = bX + bdX * dt
        bY = bY + bdY * dt
    end
end

function love.draw()
    push:apply("start")

    -- clear screen with color
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- draw welcome text
    love.graphics.setFont(sFont)
    love.graphics.printf("pong", 0, 20, VWIDTH, "center")

    love.graphics.setFont(lFont)
    love.graphics.print(tostring(p1Score), VWIDTH / 2 - 50, VHEIGHT / 10)
    love.graphics.print(tostring(p2Score), VWIDTH / 2 + 30, VHEIGHT / 10)

    -- render first paddle (left side)
    love.graphics.rectangle("fill", PADDING, p1Y, BAR_WIDTH, BAR_HEIGHT)

    -- render second paddle (right side)
    love.graphics.rectangle("fill", VWIDTH - PADDING - BAR_WIDTH, p2Y, BAR_WIDTH, BAR_HEIGHT)

    -- render ball (center)
    love.graphics.rectangle("fill", bX, bY, 4, 4)
    push:apply("end")
end
