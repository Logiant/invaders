love.graphics.setDefaultFilter('nearest', 'nearest') --remove scaling interpolation
require 'enemy' --enemy spawning script
require 'player' --player script
require 'config' --config script to load enemies

--screen size
screenWidth = love.graphics.getWidth()
screenHeight = love.graphics.getHeight()

--game states
game_over = false
win = false

function love.load()
  --load game resources
  music = love.audio.newSource('res/audio/song.wav')
  music:setLooping(true)
  pixel = love.graphics.newImage('res/img/pixel.png')
  background = love.graphics.newImage('res/img/background.png')
  --get list of modded enemies
  list = loadEnemies()
  --setup game window environment
  music:play()
  love.window.setTitle("SPAAAACE")
  bgScale = math.max(screenWidth, screenHeight) / math.min(background:getWidth(), background:getHeight());
  bigText = love.graphics.newFont(64)

  --load different objects
  enemy_controller:load(list)
  player.load()

  --spawn enemies
  local dx = enemySize + 4
  for x = 5, 720, dx do
    enemy_controller:spawn(x, 40);
  end

end --love.load()


function love.update(dt)
  --if the game isn't lost then update everythings movement!
  if game_over==false then --if the game isn't over
    --update the player
    player.update(dt)
    enemy_controller:checkCollision(player.bullets);

    if next(enemy_controller.enemies) == nil then --if there are no emenies
      win = true
    end
  end

  --update enemy movement
  enemy_controller:update(dt);

end --love.update(dt)

function love.draw()
  --set color to white so everything isnt tilted
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(background, 0, 0, 0, bgScale, bgScale)

  player.draw()

  enemy_controller:draw();
  love.graphics.setColor(128, 255, 0)

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
