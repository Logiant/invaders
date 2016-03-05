local enemy = {}


enemy.x = x
enemy.y = y
enemy.speed = 150
enemy.cooldown = 0.75
enemy.imagePath = 'res/img/enemy_blue.png'

enemy.update = function(self, dt)
  self.x = self.x + self.speed*dt*self.direction;
  if self.x + self.sizex > screenWidth-5 and self.direction > 0 then
       self.direction = self.direction * -1
         self.y = self.y + 60
     elseif self.x < 5 and self.direction < 0 then
       self.direction = self.direction * -1
       self.y = self.y + 60
     end
end

return enemy
