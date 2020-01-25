if not SERVER then return end

module( "PLEVELS", package.seeall )

require("mysqloo")

local queue = {}

local db = mysqloo.connect(PLEVELS_DATA.config.MySQL.HOST, PLEVELS_DATA.config.MySQL.USERNAME, PLEVELS_DATA.config.MySQL.PASSWORD, PLEVELS_DATA.config.MySQL.DATABASE, PLEVELS_DATA.config.MySQL.PORT)


local function query( str, callback )
	local q = db:query( str )

	function q:onSuccess( data )
		callback( data )
	end

	function q:onError( err )
		if db:status() == mysqloo.DATABASE_NOT_CONNECTED then
			table.insert( queue, { str, callback } )
			db:connect()
		return end

		print( "PLEVELS > Failed to connect to the database!" )
		print( "PLEVELS > The error returned was: " .. err )
	end

	q:start()

end

function db:onConnected()
	print( "PLEVELS > Sucessfully connected to database!" )

	for k, v in pairs( queue ) do
		query( v[ 1 ], v[ 2 ] )
	end

	queue = {}
end

function db:onConnectionFailed( err )
	print( "PLEVELS > Failed to connect to the database!" )
	print( "PLEVELS > The error returned was: " .. err )
end

db:connect()

table.insert( queue, { "SHOW TABLES LIKE 'plevels'", function( data )
	if table.Count( data ) < 1 then -- the table doesn't exist
		query( "CREATE TABLE plevels (player BIGINT UNSIGNED NOT NULL, level INTEGER UNSIGNED NOT NULL, xp DOUBLE(13, 2) UNSIGNED NOT NULL)", function( data )
			print( "PLEVELS > Sucessfully created table!" )
		end )
	end
end } )

function PLEVELS_DATA.MYSQL:PlayerJoined(ply)
  local uid = ply:SteamID64()

  query("SELECT level, xp FROM plevels WHERE player = " .. uid, function(data)
    if table.Count( data ) <= 0 then
      query("INSERT into plevels (player, level, xp) VALUES (" .. uid .. ", 1, 0)", function()
          print("PLEVELS > Successfully created player " .. ply:Nick())
        end)
    end

		if IsValid(ply) then
			PLEVELS_DATA:CachePlayer(ply, data)
	  end

  end)
end

hook.Add("PlayerInitialSpawn", "PLEVELSInitialSpawn", function(ply)
	if not IsValid(ply) or ply:IsBot() then return end
	PLEVELS_DATA.MYSQL:PlayerJoined(ply)
end)


----


function PLEVELS_DATA.MYSQL:SetLevel(id64, value)
  query("UPDATE plevels SET level = " .. value .. " WHERE player = " .. id64 .. ";", function(data)end)
end

function PLEVELS_DATA.MYSQL:SetXP(id64, value)
  query("UPDATE plevels SET xp = " .. value .. " WHERE player = " .. id64 .. ";", function(data)end)
end
