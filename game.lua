local game = {};

local funcs = require "funcs";
local object = require "object";
local player = require "player";
local food = require "food";
local bad = require "bad";
local pw = require "powerup";

local score = nil;
local frame = nil;
local spawntime = nil;
local debug = nil;
local playerobj = nil;
local win_h = nil;
local win_w = nil;
local spawncycles = nil;

local sound_get = love.audio.newSource("get.wav", "static")
local sound_pow = love.audio.newSource("pow.wav", "static")
local sound_beep = love.audio.newSource("beep.wav", "static")
local sound_hit = love.audio.newSource("hit.wav", "static")
local sound_invul = love.audio.newSource("inv.wav", "static")

local function play_sound(src)
  if src:isPlaying() then
    src:stop()
  end
    src:play()
end

function game.start()
  debug = false;
  score = 0;
  frame = 0;
  spawntime = 45;
  spawncycles = 0;
  win_h = love.graphics.getHeight();
  win_w = love.graphics.getWidth();

  playerobj = player.create_player(400, 400);
  object.add_object(playerobj);
  -- power = pw.create_powerup(400, 200);
  -- object.add_object(power);
end

function game.restart()
  local debugstate = debug;
  object.clear_objects();
  game.start();
  debug = debugstate;
end

function game.draw()
  local objlist = object.get_object_list();

  love.graphics.setBackgroundColor(0.6, 0.6, 0.6, 1.0);

  for i,v in ipairs(objlist) do
		if(v.type == "player") then
			if player.alive then
			love.graphics.draw(v.img, v.x, v.y, 0, v.scale, v.scale, v.xoffset, v.yoffset);
			end
		else
			love.graphics.draw(v.img, v.x, v.y, 0, v.scale, v.scale, v.xoffset, v.yoffset);
		end
    if(debug) then
      love.graphics.print(spawncycles, 16, 32);
      love.graphics.print(player.flash, 16, 64);
      love.graphics.print(player.ptime, 16, 48);
      love.graphics.setColor(1.0, 0, 0, 1.0);
      love.graphics.rectangle("line", v.x - v.xoffset * v.scale, v.y - v.yoffset * v.scale, v.w * v.scale, v.h * v.scale);
      love.graphics.setPointSize(4);
      love.graphics.points(v.x, v.y);
      love.graphics.setColor(1.0, 1.0, 1.0, 1.0);
    end
	end

  --draw score
  if(player.alive) then
    love.graphics.print(score, 16, 16);
  end

  --draw game over status
  if(not player.alive) then
		love.graphics.printf("You're dead.", 400, 160, 100, "center");
		love.graphics.printf("Final score: " .. score, 400, 170, 100, "center");
	end
end

function game.update()
  --update player speed
  if(player.alive) then
  if(love.mouse.isDown(1)) then
    mx, my = love.mouse.getPosition();
    speed = player.getspeed();
    angle = math.atan2(my - playerobj.y, mx - playerobj.x);
    object.set_speed(playerobj, math.cos(angle) * speed, math.sin(angle) * speed);
  else
    object.set_speed(playerobj, 0, 0);
  end

  objlist = object.get_object_list();
  for i, v in ipairs(objlist) do
    for a, b in ipairs(objlist) do
      if(i ~= a) then
        if(funcs.checkcol(v, b)) then
          if(v.type == "player" and b.type == "food") then
            score = score + 1;
            object.scale_object(playerobj, playerobj.scale + 0.2);
            object.remove_object(a);
            play_sound(sound_get)
          end
          if(v.type == "player" and b.type == "bad") then
            if(not player.power) then
              object.scale_object(playerobj, playerobj.scale - 0.2);
              play_sound(sound_hit)
            else
              play_sound(sound_invul)
            end
            object.remove_object(a);
          end
          if(v.type == "player" and b.type == "powerup") then
            player.powerup(playerobj);
            object.remove_object(a);
            play_sound(sound_pow)
          end
        end
      end
    end
    if(v.type == "player") then
      if(player.power) then
        player.ptime = player.ptime - 1;
        if(player.ptime <= 75) then
          player.flash = player.flash + 1;
        end
        if(player.ptime == 0) then
          player.unpower(playerobj);
        end
        if(player.flash == player.flashtime) then
          player.pflash(playerobj);
          player.flash = 0;
          play_sound(sound_beep)
        end
      end
    end
    if(v.type == "bad") then
      angle = math.atan2(playerobj.y - v.y, playerobj.x - v.x);
      object.set_speed(v, math.cos(angle) * bad.speed, math.sin(angle) * bad.speed);
    end
    if(playerobj.scale < 0.2) then
      player.alive = false;
    end
    object.update(v);
  end


  if(frame == spawntime) then
    spawnitems();
    frame = 0;
  end

  frame = frame + 1;
end
end

function spawncondition(c, set)
  local result = false;
  if(spawncycles < 10) then
    if(c < 2 and set == 0) then
      result = true;
    end
    if(c == 2 and set == 1) then
      result = true;
    end
  elseif(spawncycles < 22) then
    if(c < 2 and set == 0) then
      result = true;
    end
    if(c >= 1 and set == 1) then
      result = true;
    end
  end
  return result;
end

function spawnitems()
  choice = funcs.randomchoice({0, 1, 2});
  if(spawncondition(choice, 0)) then
    if(love.math.random(10) == 10) then
      powerup = pw.create_powerup(math.random(64, win_w - 64), math.random(64, win_h - 64));
      object.add_object(powerup);
    else
      newfood = food.create_food(math.random(64, win_w - 64), math.random(64, win_h - 64));
      object.add_object(newfood);
    end
  end
  if(spawncondition(choice, 1)) then
    choice_b = funcs.randomchoice({0, 1, 2, 3});
    if(choice_b == 0) then
      sx = math.random(0, win_w);
      sy = 0;
    end
    if(choice_b == 1) then
      sx = math.random(0, win_w);
      sy = win_h;
    end
    if(choice_b == 2) then
      sx = 0;
      sy = math.random(0, win_h);
    end
    if(choice_b == 3) then
      sx = win_w;
      sy = math.random(0, win_h);
    end
    newbad = bad.create_bad(sx, sy);
    object.add_object(newbad);
    spawncycles = spawncycles + 1;
  end
end

function game.keypressed(key, scancode, isrepeat)
  if(key == "escape") then
    love.event.quit();
  end
  if(key == "d") then
    debug = not debug;
  end
  if(key == "r" and not player.alive) then
    game.restart();
  end
end

function game.mousepressed(x, y, button)

end

return game;
