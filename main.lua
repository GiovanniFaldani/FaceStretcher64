require "utils"

box = {
  position = lovr.math.newVec3(0, 1.5, -1),
  size = .25
}

function lovr.load()
  -- Load a 3D model
  model = lovr.graphics.newModel('models/12140_Skull_v3_L2.obj')

  -- Use a black background
  lovr.graphics.setBackgroundColor(0, 0, 0)

  shader1 = lovr.graphics.newShader("shaders/phong.vert", "shaders/phong.frag", {})
  shader2 = lovr.graphics.newShader(customVertex, customFragment, {})
  --gShader = lovr.graphics.newShader('unlit', gradientShader, {})

  drag = {
    active = false,
    hand = nil,
    offset = lovr.math.newVec3()
  }
end

function lovr.draw(pass)
  -- Set the shader
  pass:setShader(shader1)
  pass:send('mode', 1)
  pass:send('Ka', 0.1)
  pass:send('Kd', 0.8)
  pass:send('Ks', 0.1)
  pass:send('shininessVal', 0.2)
  pass:send('ambientColor', {1,1,1})
  pass:send('diffuseColor', {0.5,0.5,0.5})
  pass:send('specularColor', {0,0,0})
  
  local lightPos = vec3(10, -100, 100)--:rotate(lovr.timer.getTime(), 0, 1, 0):translate(0,0,1))
  pass:send('lightPos', lightPos)

  -- Draw the model
  pass:draw(model, -0.5, 1, -10, 0.1, -1, 1, 0, 0)

  -- Draw a red cube using the "cube" primitive
  --pass:setColor(1, 0, 0)
  --pass:sphere(.5, 1, -3, .5, lovr.timer.getTime())

  pass:setShader(shader2)

  for i, hand in ipairs(lovr.headset.getHands()) do
    local x, y, z = lovr.headset.getPosition(hand)
    pass:sphere(x, y, z, .01)
  end

  pass:setColor(drag.active and 0x80ee80 or 0xee8080)
  pass:cube(box.position, box.size, quat(), 'line')

  for i, hand in ipairs(lovr.headset.getHands()) do
    pass:setColor(0xffffff)
    pass:cube(mat4(lovr.headset.getPose(hand)):scale(.01))
  end

end

function lovr.update(dt)
  -- This is called continuously and is passed the "delta time" as dt, which
  -- is the number of seconds elapsed since the last update.
  --
  -- You can use it to simulate physics or update game logic.
  for i, hand in ipairs(lovr.headset.getHands()) do
    if lovr.headset.wasPressed(hand, 'trigger') or lovr.system.isKeyDown("space") then
      local offset = box.position - vec3(lovr.headset.getPosition(hand))
      local halfSize = box.size / 2 --activation range
      local x, y, z = offset:unpack()
      if math.abs(x) < halfSize and math.abs(y) < halfSize and math.abs(z) < halfSize then
        drag.active = true
        drag.hand = hand
        drag.offset:set(offset)
      end
    end
  end
  
  if drag.active then
    local handPosition = vec3(lovr.headset.getPosition(drag.hand))
    box.position:set(handPosition + drag.offset)

    if lovr.headset.wasReleased(drag.hand, 'trigger') or not lovr.system.isKeyDown('space') then
      drag.active = false
    end
  end
  -- print('updating', dt)
end