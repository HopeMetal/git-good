local bad = {};

local object = require "object";

local w = 32;
local h = 32;
local of_x = w / 2;
local of_y = h / 2;
local img = love.graphics.newImage("bad.png");
bad.speed = 2;

function bad.create_bad(x, y)
  obj = object.new_object("bad", x, y, w, h, img, 0, 0, 1, of_x, of_y, {});
	return obj;
end

return bad;
