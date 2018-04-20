local object = {};

objlist = {};

function object.add_object(obj)
  table.insert(objlist, obj);
end

function object.remove_object(ind)
  table.remove(objlist, ind);
end

function object.clear_objects()
  objlist = {};
end

function object.get_object_list()
  return objlist;
end

function object.new_object(type, x, y, w, h, img, sp_x, sp_y, scale, xoffset, yoffset, extra)
  obj = {};
  obj.type = type; --number for identification
  obj.x = x; --object x position
  obj.y = y; --object y position
  obj.h = h; --object bounding box height
  obj.w = w; --object bounding box width
  obj.img = img; --object image
  obj.sp_x = sp_x; --object x speed
  obj.sp_y = sp_y; --object y speed
  obj.scale = scale; --object scale
  obj.xoffset = xoffset; --object image x offset
  obj.yoffset = yoffset; --object image y offset
  obj.extra = extra; --anything else???

  return obj;
end

function object.set_pos(obj, x, y)
  obj.x = x;
  obj.y = y;
end

function object.set_speed(obj, sp_x, sp_y)
  obj.sp_x = sp_x;
  obj.sp_y = sp_y;
end

function object.scale_object(obj, scale)
  obj.scale = scale;
end

function object.update(obj)
  object.set_pos(obj, obj.x + obj.sp_x, obj.y + obj.sp_y);
end

return object;
