function PLEVELS_DATA:OpenAdminMenu()
  local ply = LocalPlayer()
  if not ply:IsSuperAdmin() then return end

  local frame = vgui.Create("DFrame")
  frame:SetPos(50, 50)
  frame:SetSize(1000, 600)
  frame:SetTitle("Player-Levels Admin")
  frame:MakePopup()
  frame:Center()
  frame:SetSizable(true)

  local player_list = vgui.Create("DListView", frame)
  player_list:SetSize(1000, 575)
  player_list:SetPos(0, 25)
  player_list:AddColumn("Player")
  player_list:AddColumn("Level")
  player_list:AddColumn("XP")
  player_list:SetMultiSelect(false)

  for k,v in ipairs(player.GetAll()) do
    player_list:AddLine(v:Nick(), PLEVELS_DATA:GetLevel(v), math.Round(PLEVELS_DATA:GetXP(v), 2))
  end

  player_list.OnClickLine = function(parent, line, selected)
    local select_ply = line:GetColumnText(1)

    local menu = DermaMenu()

    menu:AddOption("Set Level", function()
      Derma_StringRequest(
        "Set Level for " .. select_ply,
        "Set Level to...",
        "",
        function(str)
          if not str or not tonumber(str) then return end

          net.Start("PLEVELS_SETLEVEL")
          net.WriteString(select_ply)
          net.WriteInt(tonumber(str), 32)
          net.SendToServer()
          line:SetColumnText(2, str)
        end
      )
    end)

    menu:AddOption("Set XP", function()
      Derma_StringRequest(
        "Set XP for " .. select_ply,
        "Set XP to...",
        "",
        function(str)
          if not str or not tonumber(str) then return end

          net.Start("PLEVELS_SETXP")
          net.WriteString(select_ply)
          net.WriteFloat(util.StringToType(str, "float"))
          net.SendToServer()
          line:SetColumnText(3, str)
        end
      )
    end)

    menu:AddSpacer()
    menu:Open()

  end

end
