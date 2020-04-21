if not SERVER then return end

net.Receive("PLEVELS_SETLEVEL", function(len, ply)
  if not ply:IsSuperAdmin() then return end

  local pNick = net.ReadString()
  local level = net.ReadInt(32)
  local ply

  for k,v in ipairs(player.GetAll()) do
    if v:Nick() == pNick then ply = v break end
  end

  if not ply or not IsValid(ply) then return end

  PLEVELS_DATA:SetLevel(ply, level)
end)

net.Receive("PLEVELS_SETXP", function(len, ply)
  if not ply:IsSuperAdmin() then return end

  local pNick = net.ReadString()
  local xp = net.ReadFloat()
  local ply

  for k,v in ipairs(player.GetAll()) do
    if v:Nick() == pNick then ply = v break end
  end

  if not ply or not IsValid(ply) then return end

  PLEVELS_DATA:SetXP(ply, xp)
end)
