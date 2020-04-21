PLEVELS_DATA = {}
PLEVELS_DATA.config = {}
PLEVELS_DATA.MYSQL = {}
PLEVELS_DATA.level_ups = {}

include("sv_config.lua")
include("sv_mysql.lua")
include("sv_events.lua")
include("sv_cache.lua")
include("sv_stats.lua")
include("sv_net.lua")

include("plevels/shared/sh_storage.lua")
include("plevels/shared/sh_stats.lua")
include("plevels/shared/sh_utils.lua")


util.AddNetworkString("PLEVELS_LEVELUP")
util.AddNetworkString("PLEVELS_SETLEVEL")
util.AddNetworkString("PLEVELS_SETXP")

timer.Create("PLEVELS_LEVELUP_POPUP", 6, 0, function()
  if table.IsEmpty(PLEVELS_DATA.level_ups) then return end

  local first_key = table.GetKeys(PLEVELS_DATA.level_ups)[1]

  if not IsValid(first_key) then
    PLEVELS_DATA.level_ups[first_key] = nil
  end

  net.Start("PLEVELS_LEVELUP")
  net.WriteEntity(first_key)
  net.WriteUInt(PLEVELS_DATA:GetLevel(first_key), 10)
  net.WriteBool(true)
  net.Broadcast()

  PLEVELS_DATA.level_ups[first_key] = nil

end)
