local enemy = {}


enemy.x = x
enemy.y = y
enemy.speed = 150
enemy.cooldown = 0.75
enemy.imagePath = 'res/img/GreenEnemy.png'
enemy.numFrames = 4
enemy.tileSize = 16

enemy.update = function(self, dt)
  self.animation:update(dt)
  self.x = self.x + self.speed*dt*self.direction;
     if self.x + enemySize > screenWidth-5 and self.direction > 0 then
       self.direction = self.direction * -1
         self.y = self.y + enemySize + 5
     elseif self.x < 5 and self.direction < 0 then
       self.direction = self.direction * -1
       self.y = self.y + enemySize + 5
     end
end

return enemy
