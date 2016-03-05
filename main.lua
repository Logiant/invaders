love.graphics.setDefaultFilter('nearest', 'nearest') --remove scaling interpolation
require 'enemy' --enemy spawning script
require 'player' --player script

game_over = false;
win = false;

function love.load()
  --load game resources
  music = love.audio.newSource('res/audio/music.mp3')
  music:setLooping(true)
  --setup game window environment
  music:play()
  love.window.setTitle("SPAAAACE")
  background = love.graphics.newImage('res/img/background.png')
  bgScale = 2;
  bigText = love.graphics.newFont(64)

  --load different objects
  enemy_controller:load()
  player.load()

  --spawn enemies
  for x = 60, 720, 60 do
    enemy_controller:spawn(x, 40);
  end

end --love.load()


function love.update(dt)
  --if the game isn't lost then update everythings movement!
  if game_over==false then
    --update the player and all enemies
    player.update(dt)
    enemy_controller:update(dt);
    checkCollision(enemy_controller.enemies, player.bullets);

    if next(enemy_controller.enemies) == nil then --if there are no emenies
      win = true
    end

  end

end --love.update(dt)

function love.draw()
  --set color to white so everything isnt tilted
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(background, 0, 0, 0, bgScale, bgScale)

  player.draw()

  enemy_controller:draw();

  if game_over then --write game over text!
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(bigText);
    love.graphics.print("Game Over!", love.graphics.getWidth()/2 -100, love.graphics.getHeight()/2)

  elseif win then
      love.graphics.setColor(255, 255, 255) --write win text!
      love.graphics.setFont(bigText);
      love.graphics.print("You Win!", love.graphics.getWidth()/2 -100, love.graphics.getHeight()/2)
    end
end --love.draw()




function checkCollision(enemies, bullets) -- do an O(nxm) search for collision
  for i,e in ipairs(enemies) do
    for j,b in ipairs(bullets) do
        if b.y >= e.y and b.y <= e.y + e.sizey and b.x > e.x and b.x < e.x + e.sizex then
          table.remove(enemies, i);
          table.remove(bullets, j);
        end
    end
  end
end --checkCollision(enemies, bullets)
