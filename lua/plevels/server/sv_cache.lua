if not SERVER then return end

function PLEVELS_DATA:CachePlayer(ply, data)
  local stats = {}

  if table.Count(data) < 1 then
    self:SetLevel(ply, 1)
    self:SetXP(ply, 0)
  else
    self:SetLevel(ply, data[1].level)
    self:SetXP(ply, data[1].xp)
  end
end


function PLEVELS_DATA:IsCached(ply)
  return ply:GetNWInt("plevels_level", nil) ~= 0
end



function PLEVELS_DATA:UpdatePlayer(ply)
  if not self:IsCached(ply) or not ply:IsConnected() then return end

  self.MYSQL:SetLevel(ply:SteamID64(), self:GetLevel(ply))
  self.MYSQL:SetXP(ply:SteamID64(), self:GetXP(ply))
end


function PLEVELS_DATA:UpdateAll()
  for k,v in ipairs(player.GetAll()) do
    if IsValid(v) and self:IsCached(v) and not v:IsBot() then
      self:UpdatePlayer(v)
    end
    self:CheckPlayer(v)
  end
end
timer.Create("PLEVELS_TIMER", PLEVELS_DATA.config.SaveFrequency, 0, function() PLEVELS_DATA:UpdateAll() end)

function PLEVELS_DATA:CheckPlayer(ply)
  if IsValid(ply) and not ply:IsBot() and not self:IsCached(ply) and ply:IsConnected() then
    self.MYSQL:PlayerJoined(ply)
  end
end

function PLEVELS_DATA:CheckAll()
  for k,v in ipairs(player.GetAll()) do
    if IsValid(v) and not v:IsBot() and not self:IsCached(v) and v:IsConnected() then
      self.MYSQL:PlayerJoined(v)
    end
  end
end
