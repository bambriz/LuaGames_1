--Bryan Ambriz
-- test variables
local margin = 80
local base_x = 100
local base_y = 100
--logic vars
local collisions = {}
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

--wall
local wall = {}
wall.position_x = 0
wall.position_y = 0
wall.width = 50
wall.height = 30
--walls
local walls = {}
walls.current_level_walls = {}
walls.wall_thickness = 10

--Bricks
local bricks = {}
bricks.rows = 8                    --(*1a)
bricks.columns = 11
bricks.top_left_position_x = 70
bricks.top_left_position_y = 50
bricks.brick_width = 50
bricks.brick_height = 30
bricks.horizontal_distance = 10
bricks.vertical_distance = 15      --(*1b)
bricks.current_level_bricks = {}

--walls functions
function walls.new_wall( position_x, position_y, width, height )
   return( { position_x = position_x,
             position_y = position_y,
             width = width,
             height = height } )
end
function walls.construct_walls()
   local left_wall = walls.new_wall(
      0,
      0,
      walls.wall_thickness,
      love.graphics.getHeight()
   )
   local right_wall = walls.new_wall(
      love.graphics.getWidth() - walls.wall_thickness,
      0,
      walls.wall_thickness,
      love.graphics.getHeight()
   )
   local top_wall = walls.new_wall(
      0,
      0,
      love.graphics.getWidth(),
      walls.wall_thickness
   )
   local bottom_wall = walls.new_wall(
      0,
      love.graphics.getHeight() - walls.wall_thickness,
      love.graphics.getWidth(),
      walls.wall_thickness
   ) 
   walls.current_level_walls["left"] = left_wall
   walls.current_level_walls["right"] = right_wall
   walls.current_level_walls["top"] = top_wall
   walls.current_level_walls["bottom"] = bottom_wall
end
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


     
--logic functions
function collisions.resolve_collisions()
   collisions.ball_platform_collision( ball, platform )
   collisions.ball_walls_collision( ball, walls )
   collisions.ball_bricks_collision( ball, bricks )
   collisions.platform_walls_collision( platform, walls )
  end
  
function collisions.check_rectangles_overlap( alpha, omega)
      local overlap = false
      local shift_omega_x, shift_omega_y = 0, 0
      if not(alpha.x +alpha.width < omega.x or omega.x + omega.width < alpha.x or 
        alpha.y + alpha.height < omega.y or omega.y + omega.height < alpha.y) then 
         overlap = true
        if(alpha.x + alpha.width /2) <(omega.x +omega.width/2) then
          shift_omega_x = (alpha.x+alpha.width) - omega.x 
        else 
          shift_omega_x = alpha.x - (omega.x +omega.width)
        end
        if(alpha.y + alpha.height /2) <(omega.y +omega.height/2) then
          shift_omega_y = (alpha.y+alpha.height) - omega.y 
        else 
          shift_omega_y = alpha.y - (omega.y +omega.height)
        end
      end
      return overlap, shift_omega_x, shift_omega_y
    end
    
function collisions.ball_platform_collision( ball, platform )
    local overlap, shift_ball_x, shift_ball_y
   local a = { x = platform.position_x,                  --(*1)
               y = platform.position_y,
               width = platform.width,
               height = platform.height }
   local b = { x = ball.position_x - ball.radius,        --(*1)
               y = ball.position_y - ball.radius,
               width = 2 * ball.radius,
               height = 2 * ball.radius }
    overlap, shift_ball_x, shift_ball_y = collisions.check_rectangles_overlap( a, b )
   if overlap then   --(*2)
      ball.rebound(shift_ball_x, shift_ball_y)                --(*3)
   end      
end

function collisions.ball_bricks_collision( ball, bricks )
   local b = { x = ball.position_x - ball.radius,           --(*1)
               y = ball.position_y - ball.radius,
               width = 2 * ball.radius,
               height = 2 * ball.radius }
   for i, brick in pairs( bricks.current_level_bricks ) do  --(*2)
      local a = { x = brick.position_x,                     --(*3)
                  y = brick.position_y,
                  width = brick.width,
                  height = brick.height }
      if collisions.check_rectangles_overlap( a, b ) then   --(*4)
         print( "ball-brick collision" )
      end
   end
end

function collisions.ball_walls_collision( ball, walls )
   local b = { x = ball.position_x - ball.radius,           --(*1)
               y = ball.position_y - ball.radius,
               width = 2 * ball.radius,
               height = 2 * ball.radius }
   for i, wall in pairs( walls.current_level_walls ) do  --(*2)
      local a = { x = wall.position_x,                     --(*3)
                  y = wall.position_y,
                  width = wall.width,
                  height = wall.height }
      if collisions.check_rectangles_overlap( a, b ) then   --(*4)
         print( "ball-wall collision" )
      end
   end
end

function collisions.platform_walls_collision( ball, walls )
   local b = { x = platform.position_x,                  --(*1)
               y = platform.position_y,
               width = platform.width,
               height = platform.height }
   for i, wall in pairs( walls.current_level_walls ) do  --(*2)
      local a = { x = wall.position_x,                     --(*3)
                  y = wall.position_y,
                  width = wall.width,
                  height = wall.height }
      if collisions.check_rectangles_overlap( a, b ) then   --(*4)
         print( "platform-wall collision" )
      end
   end
end

function love.keyreleased( key, code )
   if  key == 'escape' then
      love.event.quit()
   end    
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

function bricks.update_brick(single_brick)
  
end
function walls.update_wall(single_wall)
  
  end
function bricks.update(dt)
   for _, brick in pairs( bricks.current_level_bricks ) do
      bricks.update_brick( brick )
   end
end
function walls.update(dt)
    for _, wall in pairs( walls.current_level_walls ) do
      walls.update_wall( wall)
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

function bricks.draw_brick(single_brick)
  love.graphics.rectangle( 'line',
                            single_brick.position_x,
                            single_brick.position_y,
                            single_brick.width,
                            single_brick.height
    )
end
function walls.draw_wall(single_wall)
   love.graphics.rectangle( 'line',
                            single_wall.position_x,
                            single_wall.position_y,
                            single_wall.width,
                            single_wall.height
    )
  end


function bricks.draw()
    for _, brick in pairs( bricks.current_level_bricks ) do   --(*1)
      bricks.draw_brick( brick )
   end
  end
  
function walls.draw()
    for _, wall in pairs( walls.current_level_walls ) do   --(*1)
      walls.draw_wall( wall )
   end
  end

--Main functions
function love.load()
  bricks.make_level()
  walls.construct_walls()
end

function love.update(dt)
  --update ball position
  ball.update(dt)
  --platform controls
  platform.update(dt)
  --level update
  bricks.update( dt )
  walls.update(dt)
  --logic update
  collisions.resolve_collisions()
  
end

function love.draw()
 
  --draw ball
  ball.draw()
  -- draw platform
  platform.draw()
  -- draw level
  bricks.draw()
  walls.draw()
end

--what to do when game quits
function love.quit()
  print("Thank you for playing.")
end

function bricks.make_level()
  --
     for row = 1, bricks.rows do
      for col = 1, bricks.columns do
         local new_brick_position_x = bricks.top_left_position_x +   --(*2)
            ( col - 1 ) *
            ( bricks.brick_width + bricks.horizontal_distance )
         local new_brick_position_y = bricks.top_left_position_y +   --(*2)
            ( row - 1 ) *
            ( bricks.brick_height + bricks.vertical_distance )     
         local new_brick = bricks.new_brick( new_brick_position_x,   --(*3)
                                             new_brick_position_y )
         bricks.add_to_current_level_bricks( new_brick )             --(*4)
      end      
   end 
   
end