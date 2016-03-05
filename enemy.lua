enemy = {}
enemy_controller = {enemies = {}}

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
  for _,e in pairs(self.enemies) do
    e.x = e.x + e.speed*dt*e.direction;
    if e.x + e.sizex > 795 and e.direction > 0 then
      e.direction = e.direction * -1
      e.y = e.y + 60
    elseif e.x < 5 and e.direction < 0 then
      e.direction = e.direction * -1
      e.y = e.y + 60
    end
    if e.y > 400 then
      game_over = true
    end

  end
end



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
end
