enemy = {}
enemy_controller = {enemies = {}, particles = {}}

function enemy_controller:load()
  image = love.graphics.newImage('res/img/enemy_green.png');
end

function enemy_controller:spawn(x, y)
  enemy = {}
  enemy.x = x; enemy.y = y; enemy.speed = 150; enemy.direction = 1;
  enemy.sizex = 40; enemy.sizey = 40;
  enemy.cooldown = 0.75;
  enemy.lastFire = 0;
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
    e.x = e.x + e.speed*dt*e.direction;
    if e.x + e.sizex > 795 and e.direction > 0 then
      e.direction = e.direction * -1
      e.y = e.y + 60
    elseif e.x < 5 and e.direction < 0 then
      e.direction = e.direction * -1
      e.y = e.y + 60
    end
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
    love.graphics.draw(image, e.x, e.y, 0, 4, 4)
  end
  for _,p in pairs(self.particles) do
    love.graphics.draw(p.ps, p.x, p.y)
  end
end



function enemy_controller:checkCollision(bullets) -- do an O(nxm) search for collision
  for i,e in ipairs(self.enemies) do
    for j,b in ipairs(bullets) do
        if b.y >= e.y and b.y <= e.y + e.sizey and b.x > e.x and b.x < e.x + e.sizex then
          particle = {}
          particle.ps = createParticleSystem()
          particle.x = self.enemies[i].x + self.enemies[i].sizex/2
          particle.y = self.enemies[i].y + self.enemies[i].sizey/2
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
