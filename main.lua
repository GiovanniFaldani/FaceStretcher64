require "utils"
function lovr.conf(t)
  t.graphics.shaderCache = false
end


function lovr.load()
  -- Load a 3D model
  model = lovr.graphics.newModel('models/12140_Skull_v3_L2.obj')

  -- Use a black background
  lovr.graphics.setBackgroundColor(0, 0, 0)

  shader = lovr.graphics.newShader("shaders/phong.vert", "shaders/phong.frag", {})
  --gShader = lovr.graphics.newShader('unlit', gradientShader, {})
end

function lovr.draw(pass)
  -- Set the shader
  pass:setShader(shader)
  pass:send('mode', 1)
  pass:send('Ka', 0.1)
  pass:send('Kd', 0.8)
  pass:send('Ks', 0.1)
  pass:send('shininessVal', 0.2)
  pass:send('ambientColor', {1,1,1})
  pass:send('diffuseColor', {0.5,0.5,0.5})
  pass:send('specularColor', {0,0,0})
  
  local lightPos = vec3(mat4(10, -100, 100))--:rotate(lovr.timer.getTime(), 0, 1, 0):translate(0,0,1))
  pass:send('lightPos', lightPos)

  -- Draw the model
  pass:draw(model, -0.5, 1, -10, 0.1, -1, 1, 0, 0)

  -- Draw a red cube using the "cube" primitive
  --pass:setColor(1, 0, 0)
  --pass:sphere(.5, 1, -3, .5, lovr.timer.getTime())
end

function lovr.update(dt)
  -- This is called continuously and is passed the "delta time" as dt, which
  -- is the number of seconds elapsed since the last update.
  --
  -- You can use it to simulate physics or update game logic.

  print('updating', dt)
end