PLEVELS_DATA = {}

include("cl_levels.lua")
include("cl_menu.lua")

concommand.Add("plevels_admin", function(ply)
  PLEVELS_DATA:OpenAdminMenu()
end)
