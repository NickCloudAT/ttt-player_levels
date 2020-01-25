if SERVER then
  include("plevels/server/sv_init.lua")
  AddCSLuaFile("plevels/client/cl_init.lua")
  AddCSLuaFile("plevels/client/cl_levels.lua")
  AddCSLuaFile("plevels/shared/sh_storage.lua")
  AddCSLuaFile("plevels/shared/sh_stats.lua")
else
  include("plevels/client/cl_init.lua")
  include("plevels/shared/sh_storage.lua")
  include("plevels/shared/sh_stats.lua")
end
