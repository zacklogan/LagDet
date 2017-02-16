if SERVER then
lagdetect = "on"
print("Lag detection starting...")
EntitysLagg = 0
EntityslastOS = 0
EntitysTimer = 1
Entitystbl = {}
EntitysCanFreeze = {
    "prop_physics"
}
EntitysMinThinks = 40
timer.Simple(5,function() -- to ignore the thinks at startup (it always lags then:P)
    hook.Add("Think","EntitysLagg",function() -- add the hook
        EntitysTimer = EntitysTimer + 1 -- add the checker
        if os.time() != EntityslastOS then -- if theres a second passed
            EntitysOScheck() -- do the check function
            EntityslastOS = os.time() -- update the last time!
        end
    end)
end)

function EntitysOScheck() 
    if lagdetect == "on" then
    if EntitysTimer <= EntitysMinThinks then 
        EntitysLagg = EntitysLagg + 1
    elseif EntitysLagg > 0 then 
        EntitysLagg = EntitysLagg - 1
    end
    
    if EntitysLagg >= 10 then
        local seeasayAccess = "ulx seeasay"
        local players = player.GetAll()
        print("Server: Lag detection has been tripped. TPS: " .. EntitysTimer)
        for i=#players, 1, -1 do
            local t = players[ i ]
            if ULib.ucl.query( t, seeasayAccess ) then
                t:PrintColor(Color( 255, 0, 0 ), "[Admin Notification]:", Color( 255, 255, 255 ), " Server appears to be lagging, lets try fixing that. | TPS: " .. EntitysTimer )
            end
        end
        RunConsoleCommand("ulx", "lag")
        EntitysLagg = 0 
    end 
    
    EntitysTimer = 0
    end
end

util.AddNetworkString( "PrintColor" )

local Meta = FindMetaTable( "Player" )

function Meta:PrintColor( ... )

	net.Start( "PrintColor" )
		net.WriteTable( { ... } )
	net.Send( self )
end

end

function ulx.lagoff( calling_ply )
    lagdetect = "off"
    ulx.fancyLogAdmin( calling_ply, "#A turned off the lag detection system" )
end
local lagoff = ulx.command( "Lag Detect", "ulx lagoff", ulx.lagoff, "!lagoff" )
lagoff:defaultAccess( ULib.ACCESS_ADMIN )
lagoff:help( "Turns off lag dectection" )

function ulx.lagon( calling_ply )
    lagdetect = "on"
    ulx.fancyLogAdmin( calling_ply, "#A turned on the lag detection system" )
end
local lagon = ulx.command( "Lag Detect", "ulx lagon", ulx.lagon, "!lagon" )
lagon:defaultAccess( ULib.ACCESS_ADMIN )
lagon:help( "Turns on lag detection." )

function ulx.lagtrigger( calling_ply, tps )
	EntitysMinThinks = tps
	ulx.fancyLogAdmin( calling_ply, "#A changed the lag detection trigger to #i TPS", tps )
end

local lagtps = ulx.command( "Lag Detect", "ulx lagtrigger", ulx.lagtrigger, "!lagtrigger" )
lagtps:addParam{ type=ULib.cmds.NumArg, min=30, default=30, hint="TPS", ULib.cmds.round }
lagtps:defaultAccess( ULib.ACCESS_ADMIN )
lagtps:help( "Changes the TPS the lag detection will go off at." )

function ulx.lag( calling_ply )
	local i = 0
	for k, v in pairs( ents.FindByClass( "prop_*" ) ) do
		local phys = v:GetPhysicsObject()
		if (IsValid(phys)) then
			if(phys:IsMotionEnabled) {
				i = i + 1
				phys:EnableMotion(false)
			}
		end
	end
  if not calling_ply:IsValid() then
			print("Server: Command issued! Props Froze: " .. i )
	else
    for c=#players, 1, -1 do
      local t = players[ c ]
      if ULib.ucl.query( t, seeasayAccess ) then
        t:PrintColor(Color( 255, 0, 0 ), "[Admin Notification]:", Color( 255, 255, 255 ), " " .. calling_ply .. " has froze a total of " .. i .. " props!" )
      end    
    end
	end
end
local lag = ulx.command( "Lag Detect", "ulx lag", ulx.lag, "!lag" )
lag:defaultAccess( ULib.ACCESS_ADMIN )
lag:help( "Freezes all props to prevent lag." )
