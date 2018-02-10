--Bryan Ambriz

local margin = 80
local num_bricks = 8
local base_x = 100
local base_y = 200
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
bricks.brick_height = 20
bricks.brick_width = 40
bricks.current_level_bricks = {}

--bricks functions
function bricks.new_brick( position_x, position_y, width, height)
  return({ position_x = position_x,
             position_y = position_y,
             width = width or bricks.brick_width,           --(*1)
             height = height or bricks.brick_height })
end
function bricks.add_to_current_level_bricks(brick)
  table.insert( bricks.current_level_bricks, brick)
end
--


     
--
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

function bricks.update_brick(single_brick)
  
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

function bricks.draw_brick(single_brick)
  love.graphics.rectangle( 'line',
                            single_brick.position_x,
                            single_brick.position_y,
                            single_brick.width,
                            single_brick.height
    )
end



function bricks.draw()
    for _, brick in pairs( bricks.current_level_bricks ) do   --(*1)
      bricks.draw_brick( brick )
   end
  end
function bricks.update(dt)
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.update_brick( brick )
   end
end
--Main functions
function love.load()
  bricks.make_level()
end

function love.update(dt)
  --update ball position
  ball.update(dt)
  --platform controls
  platform.update(dt)
  --level update
  bricks.update( dt )
  
end

function love.draw()
 
  --draw ball
  ball.draw()
  -- draw platform
  platform.draw()
  -- draw level
  bricks.draw()
end

--what to do when game quits
function love.quit()
  print("Thank you for playing.")
end

function bricks.make_level()
  --
    for i=1,num_bricks do bricks.add_to_current_level_bricks(bricks.new_brick((base_x+(margin*(i-1))), base_y))
        end 
   
end