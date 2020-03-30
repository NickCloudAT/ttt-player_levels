hook.Add("TTTScoreboardColumns", "TTT_PLEVELS_SC", function(pnl)
  pnl:AddColumn("Level", function(ply, label)
    return PLEVELS_DATA:GetLevel(ply)
  end, 101)
end)

net.Receive("PLEVELS_LEVELUP", function()
  local ply = net.ReadEntity()
  local level = net.ReadUInt(10)
  local global = net.ReadBool()

  local localPly = LocalPlayer()

  if global and localPly == ply then return end

  if not global then
    EPOP:AddMessage(
      {
        text = "Level UP",
        color = Color(0, 255, 0)
      },
      "You reached Level " .. tostring(level), 18
    )
    return
  end

  EPOP:AddMessage(
    {
      text = ply:Nick() .. " Leveled UP",
      color = Color(0, 255, 0)
    },
    ply:Nick() .. " reached Level " .. tostring(level), 10
  )

end)
