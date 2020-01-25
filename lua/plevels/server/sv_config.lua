if not SERVER then return end

PLEVELS_DATA.config.MySQL = {
  HOST = "localhost",
  PORT = "3306",
  USERNAME = "dbuser",
  PASSWORD = "dbpassword",
  DATABASE = "db"
}

PLEVELS_DATA.config.SaveFrequency = "120"

if not file.Exists("plevels/config.json", "DATA") then
  file.CreateDir("plevels")
  file.Write("plevels/config.json", util.TableToJSON(PLEVELS_DATA.config, true))
else
  local configFile = file.Read("plevels/config.json", "DATA")
  if not configFile then return end

  PLEVELS_DATA.config = util.JSONToTable(configFile)
end
