--Bryan Ambriz

--Game objects

--Ball
local ball = {}
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300

--Platform
local platform = {}
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300

--Brick
local brick = {}
brick.position_x = 100
brick.position_y = 100


function love.load()
end

function love.update(dt)
  ball.position_x = ball.position_x + ball.speed_x * dt --(*1)
  ball.position_y = ball.position_y + ball.speed_y * dt
  if love.keyboard.isDown('right') then 
    platform.position_x = platform.position_x+(platform.speed_x*dt)
  end
  if love.keyboard.isDown('left') then 
    platform.position_x = platform.position_x-(platform.speed_x*dt)
  end
end

function love.draw()
end
