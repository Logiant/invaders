player = {} --player forward declaration

--these funcations are not colons because there is only one global player
function player.load()
  player.image = love.graphics.newImage('res/img/player.png')
  player.shootSfx = love.audio.newSource('res/audio/laserfx.mp3', 'static')
  player.x = 40; player.y = 525
  player.sizex = 40; player.sizey = 40 --ingame player size
  player.imgSclX = player.sizex/player.image:getWidth()  --player img scale
  player.imgSclY = player.sizey/player.image:getHeight() --player img scale
  player.speed = 300 --speed in pixels per second
  player.cooldown = 0.75; player.lastFire = 0 --attack timers
  player.bullets = {} --table of bullets

  player.fire = function() --function to create more bullets
    bullet = {} --bullet forward declaration
    bullet.size = 10
    bullet.x = player.x + player.sizex/2 - bullet.size/2
    bullet.y = player.y
    bullet.speed = -250
    table.insert(player.bullets, bullet)
    player.lastFire = -player.cooldown; --reset attack timer
  end

end

function player.draw()
  love.graphics.setColor(255, 255, 255) --clear to white
  love.graphics.draw(player.image, player.x, player.y, 0, player.imgSclX, player.imgSclY)

  -- draw the bullets white
  for _,b in pairs(player.bullets) do
    love.graphics.rectangle('fill', b.x, b.y, b.size, b.size)
  end

end --player.draw()

function player.update(dt)
  --increment the player shoot cooldown timer
  player.lastFire = player.lastFire + dt
  --get player iunput and move
  player.move(dt)
  --remove any bullets that travel off the screen
  for i,b in ipairs(player.bullets) do
    if b.y < -10 then
      table.remove(player.bullets, i);
    end
    b.y = b.y + bullet.speed*dt
  end
end --player.update(dt)



function player.move(dt)
  horiz = 0; --controls player motion
  if love.keyboard.isDown("d") then
    horiz = horiz + 1;
  end if love.keyboard.isDown("a") then
    horiz = horiz - 1;
  end
  --move the player
  player.x = player.x + horiz*player.speed*dt
  --stay within screen bounds!
  if player.x + player.sizex > screenWidth-5 then
    player.x = screenWidth-5 - player.sizex
  end
  if player.x < 5 then
    player.x = 5
  end
  --fire the cannon!
  if love.keyboard.isDown("space") and player.lastFire > 0 then
    player.fire()
    player.shootSfx:stop()
    player.shootSfx:play()
  end
end --player.move()
