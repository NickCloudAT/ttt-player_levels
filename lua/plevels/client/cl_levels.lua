hook.Add("TTTScoreboardColumns", "TTT_PLEVELS_SC", function(pnl)
  pnl:AddColumn("Level", function(ply, label)
    return PLEVELS_DATA:GetLevel(ply)
  end, 101)
end)

net.Receive("PLEVELS_LEVELUP", function()
  local ply = net.ReadEntity()
  local level = net.ReadUInt(10)

  local localPly = LocalPlayer()

  if(ply == localPly) then
    EPOP:AddMessage(
      {
        text = "Level UP",
        color = Color(0, 255, 0)
      },
      "You reached Level " .. tostring(level), 10
    )
    return
  end

  chat.AddText(Color(0, 255, 0), ply:Nick() .. " has reached Level " .. tostring(level))

end)
