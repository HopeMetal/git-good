local funcs = {};

function funcs.enemy_upd(x, y, sp_x, sp_y)
  x = x + sp_x;
  y = y + sp_y;

  return x, y;
end

function funcs.checkcol(obj1, obj2)
  x1, y1, w1, h1 = obj1.x - obj1.xoffset * obj1.scale, obj1.y - obj1.yoffset * obj1.scale, obj1.w * obj1.scale, obj1.h * obj1.scale;
  x2, y2, w2, h2 = obj2.x - obj2.xoffset * obj2.scale, obj2.y - obj2.yoffset * obj2.scale, obj2.w * obj2.scale, obj2.h * obj2.scale;
  if(x1 > x2 + w2) then return false; end
  if(x1 + w1 < x2) then return false; end
  if(y1 > y2 + h2) then return false; end
  if(y1 + h1 < y2) then return false; end

  return true;
end

function funcs.randomchoice(t)
  return t[love.math.random(#t)];
end

return funcs;
