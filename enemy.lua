local anim8 = require 'libs/anim8'
enemySize = 64 --enemy size in pixles (collision and rendering)
enemy = {}
enemy_controller = {enemies = {}, particles = {}}
enemyTypes = {}
images = {}
str = ''

function enemy_controller:load(enemyList) --load each enemy.lua file
  numTypes = 0
  for _,t in pairs(enemyList) do
    local path = 'enemies/'..t..'.lua'

      local temp = love.filesystem.load(path)
      e = temp()
      e.image = love.graphics.newImage(e.imagePath);
      local g = anim8.newGrid(e.tileSize, e.tileSize, e.image:getWidth(), e.image:getHeight())
      e.animation = anim8.newAnimation(g('1-'..tostring(e.numFrames),1), 0.33)
      table.insert(enemyTypes, e)
      numTypes = numTypes + 1
  end
end

function enemy_controller:spawn(x, y) --clone enemy information
  local index = love.math.random(numTypes)
  enemy = {}
  enemy.update = enemyTypes[index].update
  enemy.image = enemyTypes[index].image
  enemy.animation = enemyTypes[index].animation:clone()
  enemy.animation:update(love.math.random()*2) --give the anim a random offset
  enemy.tileSize = enemyTypes[index].tileSize
  enemy.x = x; enemy.y = y
  enemy.speed = enemyTypes[index].speed; enemy.direction = 1
  enemy.cooldown = enemyTypes[index].cooldown
  enemy.lastFire = 0
  enemy.bullets = {}
  table.insert(self.enemies, enemy);
end

function enemy_controller:update(dt)
  --move particles!
  for i,p in ipairs(self.particles) do
    p.ps:update(dt)
    if p.ps:isActive()==false then
        table.remove(self.particles, i)
    end
  end
  --move enemies
  for i,e in ipairs(self.enemies) do
    e:update(dt) --called from the enemy lua behavior script
    e.animation:update(dt)
  --  e.animation:update(dt)
    --lose the game if the get past y=400
    if e.y > 400 then
      game_over = true
      table.remove(self.enemies, i)
    end

  end
end --update(dt)



function enemy:fire()
  bullet = {}
  bullet.size = 10
  bullet.x = self.x + self.sizex/2 - self.sizey/2
  bullet.y = self.y
  bullet.speed = -250
  table.insert(self.bullets, bullet)
  player.lastFire = -player.cooldown;
end


function enemy_controller:draw()
  love.graphics.setColor(255, 255, 255)
  for _,e in pairs(self.enemies) do
    e.animation:draw(e.image, e.x, e.y, 0, enemySize/e.tileSize, enemySize/e.tileSize)
  end
  for _,p in pairs(self.particles) do
    love.graphics.draw(p.ps, p.x, p.y)
  end
end



function enemy_controller:checkCollision(bullets) -- do an O(nxm) search for collision
  for i,e in ipairs(self.enemies) do
    for j,b in ipairs(bullets) do
        if b.y >= e.y and b.y <= e.y + enemySize and b.x > e.x and b.x < e.x + enemySize then
          particle = {}
          particle.ps = createParticleSystem()
          particle.x = self.enemies[i].x + enemySize/2
          particle.y = self.enemies[i].y + enemySize/2
          table.remove(self.enemies, i)
          table.insert(self.particles, particle)
          table.remove(bullets, j)
        end
    end
  end
end --checkCollision(enemies, bullets)



function createParticleSystem()
  ps = love.graphics.newParticleSystem(pixel, 64)
  ps:setParticleLifetime(0.25, 0.5); -- Particles live at least 2s and at most 5s.
  ps:setLinearAcceleration(-500, -500, 500, 500); -- Randomized movement
  ps:setColors(139, 69, 0, 255, 0, 0, 0, 128); -- Fade to black.
  ps:emit(64)
  return ps
end
