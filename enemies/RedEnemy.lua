local enemy = {}


enemy.x = x
enemy.y = y
enemy.speed = 150
enemy.cooldown = 0.75
enemy.imagePath = 'res/img/enemy_red.png'
enemy.numFrames = 1
enemy.tileSize = 10


enemy.update = function(self, dt)
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
