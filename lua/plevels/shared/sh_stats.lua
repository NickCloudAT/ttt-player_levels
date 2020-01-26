function PLEVELS_DATA:GetNeededXP(ply)
  return 100+(20*(PLEVELS_DATA:GetLevel(ply)+1))
end


if SERVER then
  function PLEVELS_DATA:GetGrantedXP(ply, id64, killed)
    local dmg_dealt = ply.plevels_damage[id64]

    if not dmg_dealt then return 0 end

    ply.plevels_damage[id64] = nil

    if dmg_dealt > 120 then dmg_dealt = 120 end

    return killed and dmg_dealt*0.015 or dmg_dealt*0.01
  end


  function PLEVELS_DATA:CheckLevelUp(ply)
    local current_xp = PLEVELS_DATA:GetXP(ply)
    local needed_xp = PLEVELS_DATA:GetNeededXP(ply)

    if current_xp < needed_xp then return end

    local difference = current_xp-needed_xp

    PLEVELS_DATA:SetXP(ply, difference)
    PLEVELS_DATA:AddLevel(ply, 1)

    net.Start("PLEVELS_LEVELUP")
    net.WriteEntity(ply)
    net.WriteUInt(PLEVELS_DATA:GetLevel(ply), 10)
    net.Broadcast()

    hook.Run("TTTPlevelsLevelUP", ply, PLEVELS_DATA:GetLevel(ply))
  end

  function PLEVELS_DATA:EndRound()
    for k,v in ipairs(player.GetAll()) do
      if not v.plevels_damage then continue end

      for id64 in pairs(v.plevels_damage) do
        PLEVELS_DATA:AddXP(v, PLEVELS_DATA:GetGrantedXP(v, id64, false))
      end
    end
  end
end
