local game = require "game";

function love.load()
  game.start();
end

function love.draw()
  game.draw();
end

function love.keypressed(key, scancode, isrepeat)
  game.keypressed(key, scancode, isrepeat);
end

function love.mousepressed(x, y, button)
  game.mousepressed(x, y, button);
end

function love.update()
  game.update();
end
