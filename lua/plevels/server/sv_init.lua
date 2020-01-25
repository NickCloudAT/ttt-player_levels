PLEVELS_DATA = {}
PLEVELS_DATA.config = {}
PLEVELS_DATA.MYSQL = {}

include("sv_config.lua")
include("sv_mysql.lua")
include("sv_events.lua")
include("sv_cache.lua")
include("sv_stats.lua")

include("plevels/shared/sh_storage.lua")
include("plevels/shared/sh_stats.lua")


AddCSLuaFile("plevels/client/cl_levels.lua")

util.AddNetworkString("PLEVELS_LEVELUP")
