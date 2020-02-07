if not SERVER then return end

function PLEVELS_DATA:CachePlayer(ply, data)
  local stats = {}

  if table.Count(data) < 1 then
    PLEVELS_DATA:SetLevel(ply, 1)
    PLEVELS_DATA:SetXP(ply, 0)
  else
    PLEVELS_DATA:SetLevel(ply, data[1].level)
    PLEVELS_DATA:SetXP(ply, data[1].xp)
  end
end


function PLEVELS_DATA:IsCached(ply)
  return ply:GetNWInt("plevels_level", nil) ~= nil
end



function PLEVELS_DATA:UpdatePlayer(ply)
  if not PLEVELS_DATA:IsCached(ply) or not ply:IsConnected() then return end

  PLEVELS_DATA.MYSQL:SetLevel(ply:SteamID64(), PLEVELS_DATA:GetLevel(ply))
  PLEVELS_DATA.MYSQL:SetXP(ply:SteamID64(), PLEVELS_DATA:GetXP(ply))
end


function PLEVELS_DATA:UpdateAll()
  for k,v in ipairs(player.GetAll()) do
    if IsValid(v) and PLEVELS_DATA:IsCached(v) and not v:IsBot() then
      PLEVELS_DATA:UpdatePlayer(v)
    end
  end
end
timer.Create("PLEVELS_TIMER", PLEVELS_DATA.config.SaveFrequency, 0, function() PLEVELS_DATA:UpdateAll() end)
