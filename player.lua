local player = {};

local object = require "object";

player.alive = nil;
player.power = nil;
player.flashtime = 15;
player.flash = 0;
player.ptime = 0;
local pstate = 0;
local pl_w = 32;
local pl_h = 32;
local pl_of_x = pl_w / 2;
local pl_of_y = pl_h / 2;
local pl = love.graphics.newImage("player.png");
local pl_2 = love.graphics.newImage("player2.png");
local pl_speed = 4;

function player.create_player(x, y)
  obj = object.new_object("player", x, y, pl_w, pl_h, pl, 0, 0, 1, pl_of_x, pl_of_y, {});
  player.alive = true;
  player.power = false;
	return obj;
end

function player.getspeed()
  return pl_speed;
end

function player.powerup(obj)
  player.power = true;
  player.ptime = 600;
  pstate = 1;
  obj.img = pl_2;
end

function player.unpower(obj)
  player.power = false;
  pstate = 0;
  player.flash = 0;
  obj.img = pl;
end

function player.pflash(obj)
  if(pstate == 0) then
    obj.img = pl_2;
    pstate = 1;
  elseif(pstate == 1) then
    obj.img = pl;
    pstate = 0;
  end
end

return player;
