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

--Bricks
local bricks = {}
bricks.current_level_bricks = {}

--bricks functions
function bricks.new_brick( position_x, position_y, width, height)
  return({ position_x = position_x,
             position_y = position_y,
             width = width or bricks.brick_width,           --(*1)
             height = height or bricks.brick_height })
end

--update functions
function ball.update(dt)
  ball.position_x = ball.position_x + ball.speed_x * dt --(*1)
  ball.position_y = ball.position_y + ball.speed_y * dt
end
function platform.update(dt)
  if love.keyboard.isDown('right') then 
    platform.position_x = platform.position_x+(platform.speed_x*dt)
  end
  if love.keyboard.isDown('left') then 
    platform.position_x = platform.position_x-(platform.speed_x*dt)
  end
end

-- draw functions
function ball.draw()
   local segments_in_circle = 16
    love.graphics.circle('line',
                        ball.position_x,
                        ball.position_y,
                        ball.radius,
                        segments_in_circle
                      )
end

function platform.draw()
  
    love.graphics.rectangle( 'line',
                            platform.position_x,
                            platform.position_y,
                            platform.width,
                            platform.height)
end

--Main functions
function love.load()
end

function love.update(dt)
  --update ball position
  ball.update(dt)
  --platform controls
  platform.update(dt)
  
end

function love.draw()
 
  --draw ball
  ball.draw()
  -- draw platform
  platform.draw()
  -- draw brick
  love.graphics.rectangle( 'line',
                            brick.position_x,
                            brick.position_y,
                            brick.width,
                            brick.height)
end

--what to do when game quits
function love.quit()
  print("Thank you for playing.")
end
