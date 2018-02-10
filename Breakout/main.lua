--Bryan Ambriz

--Game objects

--Ball
local ball = {}
ball.position_x = 300
ball.position_y = 300
ball.speed_x = 300
ball.speed_y = 300
ball.radius = 10

--Platform
local platform = {}
platform.position_x = 500
platform.position_y = 500
platform.speed_x = 300
platform.width = 70
platform.height = 20

--Brick
local brick = {}
brick.position_x = 100
brick.position_y = 100
brick.width = 50
brick.height = 30


function love.load()
end

function love.update(dt)
  --update ball position
  ball.position_x = ball.position_x + ball.speed_x * dt --(*1)
  ball.position_y = ball.position_y + ball.speed_y * dt
  --platform controls
  if love.keyboard.isDown('right') then 
    platform.position_x = platform.position_x+(platform.speed_x*dt)
  end
  if love.keyboard.isDown('left') then 
    platform.position_x = platform.position_x-(platform.speed_x*dt)
  end
end

function love.draw()
  local segments_in_circle = 16
  --draw ball
  love.graphics.circle('line',
                        ball.position_x,
                        ball.position_y,
                        ball.radius,
                        segments_in_circle
                      )
  -- draw platform
  love.graphics.rectangle( 'line',
                            platform.position_x,
                            platform.position_y,
                            platform.width,
                            platform.height)
  -- draw brick
  love.graphics.rectangle( 'line',
                            brick.position_x,
                            brick.position_y,
                            brick.width,
                            brick.height)
end
