if not SERVER then return end

hook.Add("PlayerDeath", "PLEVELS_DEATH", function(ply, inflictor, attacker)
  if GetRoundState() ~= ROUND_ACTIVE then return end

  if not IsValid(ply) or ply:IsBot() or not ply:IsTerror() then return end

  if not IsValid(attacker) or not attacker:IsPlayer() then return end

  if not attacker:IsTerror() or attacker == ply then return end

  if(ply:LastHitGroup() == HITGROUP_HEAD) then
    PLEVELS_DATA:AddXP(attacker, PLEVELS_DATA:GetGrantedXP(attacker, ply:SteamID64())*2)
    return
  end

  PLEVELS_DATA:AddXP(attacker, PLEVELS_DATA:GetGrantedXP(attacker, ply:SteamID64()))

end)

hook.Add("PlayerDisconnected", "PLEVELS_HANDLE_QUIT", function(ply)
  if not IsValid(ply) or ply:IsBot() or not PLEVELS_DATA:IsCached(ply) then return end

  PLEVELS_DATA:UpdatePlayer(ply)
end)

hook.Add("PlayerHurt", "PLEVELS_HANDLE_HURT", function(victim, attacker, remain, taken)
  if GetRoundState() ~= ROUND_ACTIVE then return end

  if not IsValid(victim) or victim:IsBot() or not victim:IsTerror() then return end

  if not IsValid(attacker) or not attacker:IsPlayer() then return end

  if not attacker:IsTerror() or attacker == victim then return end

  if not attacker.plevels_damage then attacker.plevels_damage = {} end

  if not attacker.plevels_damage[victim:SteamID64()] then
	attacker.plevels_damage[victim:SteamID64()] = 0
  end

  local beforeHealth = remain+taken

  if taken > beforeHealth then taken = beforeHealth end

  attacker.plevels_damage[victim:SteamID64()] = attacker.plevels_damage[victim:SteamID64()] + taken

end)

hook.Add("TTTPrepareRound", "PLEVELS_CLEAR_DAMAGE", function()
  for k,v in ipairs(player.GetAll()) do
    v.plevels_damage = nil
  end
end)

hook.Add("TTTEndRound", "PLEVELS_CHECK_LEVELUP", function()
  for k,v in ipairs(player.GetAll()) do
    PLEVELS_DATA:CheckLevelUp(v)
  end
  PLEVELS_DATA:UpdateAll()
end)
