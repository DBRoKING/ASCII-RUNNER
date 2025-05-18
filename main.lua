-- ASCII RUNNER --
---By DBRoKING---

local gameState = "menu"
local playerName = ""
local highScore = 0
local highScoreName = ""

function love.load()
    -- Basic setup
    font = love.graphics.newFont(20)
    fontLarge = love.graphics.newFont(30)
    love.graphics.setFont(font)
    
    -- Sound setup
    sounds = {
        menuMusic = love.audio.newSource("music/starttheme.mp3", "stream"),
        gameMusic = love.audio.newSource("music/background.mp3", "stream"),
        gameOver = love.audio.newSource("music/restarttheme.mp3", "stream")
    }
    sounds.menuMusic:setVolume(0.5)
    sounds.gameMusic:setVolume(0.4)
    sounds.gameOver:setVolume(0.6)
    
    -- Load high score
    if love.filesystem.getInfo("highscore.txt") then
        local data = love.filesystem.read("highscore.txt")
        highScore, highScoreName = data:match("(%d+),(.+)")
        highScore = tonumber(highScore) or 0
    end

    -- Player setup
    player = {
        x = 100, y = 300,
        width = 30, height = 30,
        speed = 5,
        isJumping = false,
        jumpForce = -18,
        gravity = 1.0,
        velocity = 0,
        sprite = {"(0>", "[0>"},
        frame = 1,
        color = {1,1,1}
    }

    -- Game variables
    obstacles = {}
    obstacleTimer = 0
    spawnRate = 1.5
    score = 0
    countdown = 3
    baseSpeed = 5
    
    -- Ground patterns (ASCII only)
    groundPatterns = {
        "=====/=\\=====/=\\=====/=\\====",
        "=====| |=====| |=====| |===="
    }
    currentGround = 1
    bgScroll = 0
    
    -- Mixed obstacles (ASCII + emoji)
    obstacleTypes = {
        {sprite="/^^\\", width=30, height=30, color={1,0.3,0}, y=310},  -- Fire
        {sprite="|💣|", width=30, height=30, color={1,0,0}, y=310},     -- Bomb
        {sprite="<X >", width=30, height=30, color={0.8,0.8,0.8}, y=310},-- Skull
        {sprite="🐉", width=40, height=30, color={0.8,0.1,0.1}, y=250}, -- Dragon
        {sprite="**", width=30, height=30, color={0.2,0.8,1}, y=200},   -- Comet
        {sprite="🌪️", width=40, height=40, color={0.3,0.3,0.8}, y=150} -- Tornado
    }
    
    -- Title screen (ASCII)
    menuArt = {
        "  /\\  ASCII RUNNER  /\\  ",
        "                        ",
        "    _____               ",
        "   /     \\    _O>      ",
        "  | [ ] |  /^^\\      ",
        "   \\_____/  <X>       ",
        "                        ",
        " Press ENTER to start!  ",
        " Space to jump!         "
    }
    
    -- Menu effects
    menuStars = {}
    for i=1, 100 do
        table.insert(menuStars, {
            x = love.math.random(0, 800),
            y = love.math.random(0, 600),
            size = love.math.random(1, 3),
            speed = love.math.random(20, 50),
            brightness = love.math.random() * 0.7 + 0.3
        })
    end
    
    sounds.menuMusic:setLooping(true)
    sounds.menuMusic:play()
end

function love.update(dt)
    if gameState == "menu" then
        for _, star in ipairs(menuStars) do
            star.y = star.y + star.speed * dt
            if star.y > 600 then star.y = 0 end
        end
    elseif gameState == "countdown" then
        countdown = countdown - dt
        if countdown <= 0 then 
            gameState = "playing" 
            sounds.menuMusic:stop()
            sounds.gameMusic:setLooping(true)
            sounds.gameMusic:play()
        end
    elseif gameState == "playing" then
        local speedBonus = math.min(math.floor(score / 50) * 0.2, 2.0)
        player.speed = baseSpeed + speedBonus
        
        bgScroll = bgScroll - player.speed * 0.5
        if bgScroll <= -100 then 
            bgScroll = 0 
            currentGround = currentGround == 1 and 2 or 1
        end
        
        player.velocity = player.velocity + player.gravity
        player.y = player.y + player.velocity
        player.frame = math.floor(love.timer.getTime() * 8) % 2 + 1

        if player.y > 300 then
            player.y = 300
            player.isJumping = false
            player.velocity = 0
        end

        obstacleTimer = obstacleTimer + dt
        if obstacleTimer >= spawnRate then
            spawnObstacle()
            if love.math.random() < 0.4 then spawnObstacle() end
            obstacleTimer = 0
            spawnRate = math.max(0.7, 1.5 - (score * 0.005)) * love.math.random(0.8, 1.2)
        end

        for i, obs in ipairs(obstacles) do
            obs.x = obs.x - (player.speed + 2 + love.math.random(0,1))
            if checkCollision(player, obs) then gameOver() end
            if obs.x < -50 then table.remove(obstacles, i) end
        end

        score = score + dt * 8 * (1 + speedBonus)
    end
end

function gameOver()
    gameState = "gameover"
    player.color = {1,0,0}
    sounds.gameMusic:stop()
    sounds.gameOver:play()
    
    if score > highScore then
        highScore = math.floor(score)
        highScoreName = playerName
        love.filesystem.write("highscore.txt", highScore..","..highScoreName)
    end
end

function love.draw()
    if gameState == "menu" then
        love.graphics.setBackgroundColor(0.05, 0.05, 0.15)
        for _, star in ipairs(menuStars) do
            love.graphics.setColor(1, 1, 1, star.brightness)
            love.graphics.rectangle("fill", star.x, star.y, star.size, star.size)
        end
        
        love.graphics.setFont(fontLarge)
        love.graphics.setColor(0.8, 0.8, 0)
        for i, line in ipairs(menuArt) do
            love.graphics.print(line, 150, 52 + i*30)
        end
        
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Enter name: "..playerName, 280, 350)
        love.graphics.print("Press ENTER!", 300, 400)
        
        if highScore > 0 then
            love.graphics.setColor(1, 0.8, 0)
            love.graphics.print("High Score: "..highScore.." by "..highScoreName, 20, 20)
        end
        
    elseif gameState == "countdown" then
        love.graphics.setBackgroundColor(0.2, 0.5, 0.8)
        love.graphics.setFont(fontLarge)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("READY?", 360, 220)
        love.graphics.print(math.ceil(countdown), 380, 270)
        
    elseif gameState == "playing" or gameState == "gameover" then
        love.graphics.setBackgroundColor(0.2, 0.5, 0.8)
        love.graphics.setColor(0.3, 0.2, 0.1)
        love.graphics.rectangle("fill", 0, 320, 800, 80)
        
        love.graphics.setColor(0.6, 0.5, 0.3)
        love.graphics.print(groundPatterns[currentGround], bgScroll, 330)
        love.graphics.print(groundPatterns[currentGround], bgScroll + 800, 330)

        for _, obs in ipairs(obstacles) do
            love.graphics.setColor(obs.color)
            love.graphics.print(obs.sprite, obs.x, obs.y)
        end

        love.graphics.setColor(player.color)
        love.graphics.print(player.sprite[player.frame], player.x, player.y)

        love.graphics.setFont(fontLarge)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Score: "..math.floor(score), 20, 20)
        love.graphics.print("High: "..highScore, 20, 60)
        
        if gameState == "gameover" then
            love.graphics.setColor(0, 0, 0, 0.7)
            love.graphics.rectangle("fill", 250, 200, 300, 150)
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("GAME OVER", 330, 220)
            love.graphics.print("Score: "..math.floor(score), 300, 270)
            love.graphics.print("Press ENTER to Restart!", 240, 320)
        end
    end
end

function love.keypressed(key)
    if gameState == "menu" then
        if key == "return" and playerName ~= "" then
            gameState = "countdown"
        elseif key == "backspace" then
            playerName = playerName:sub(1, -2)
        elseif #key == 1 and #playerName < 10 then
            if love.keyboard.isDown("lshift", "rshift") then
                key = key:upper()
            end
            playerName = playerName .. key
        end
        
    elseif gameState == "playing" then
        if key == "space" and not player.isJumping then
            player.velocity = player.jumpForce
            player.isJumping = true
        end
        
    elseif gameState == "gameover" then
        if key == "return" then
            sounds.gameOver:stop()
            resetGame()
            gameState = "countdown"
            sounds.menuMusic:play()
        end
    end
end

function spawnObstacle()
    local obsType = obstacleTypes[love.math.random(#obstacleTypes)]
    table.insert(obstacles, {
        x = 800 + love.math.random(0, 50),
        y = obsType.y,
        sprite = obsType.sprite,
        color = obsType.color,
        width = obsType.width,
        height = obsType.height
    })
end

function resetGame()
    player = {
        x = 100,
        y = 300,
        width = 30,
        height = 30,
        speed = 5,
        isJumping = false,
        jumpForce = -18,
        gravity = 1.0,
        velocity = 0,
        sprite = {"(0>", "[0>"},
        frame = 1,
        color = {1,1,1}
    }
    obstacles = {}
    score = 0
    countdown = 3
    spawnRate = 1.5
    bgScroll = 0
end

function checkCollision(a, b)
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end