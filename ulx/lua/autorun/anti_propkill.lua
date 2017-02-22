if CLIENT then

  net.Receive( "PrintColor", function()
    chat.AddText( unpack( net.ReadTable() ) )
  end )
  
else

  util.AddNetworkString( "PrintColor" )

  local Meta = FindMetaTable( "Player" )

  function Meta:PrintColor( ... )
    net.Start( "PrintColor" )
    net.WriteTable( { ... } )
    net.Send( self )
  end

hook.Add( "PhysgunPickup", "NoPushIndex", function(ply,ent)
	if (IsValid(ply) and IsValid(ent)) and ent.CPPICanPhysgun and ent:CPPICanPhysgun(ply) then
		local collision = ent:GetCollisionGroup()
		ent.AntiPush.Collision = (collision == COLLISION_GROUP_INTERACTIVE_DEBRIS) and COLLISION_GROUP_NONE or collision
		if collision == COLLISION_GROUP_NONE then 
			ent:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS) 
		end
	end
end)

hook.Add( "PhysgunDrop", "NoPushNoThrow", function(ply,ent)
	if (IsValid(ply) and IsValid(ent)) and ent.AntiPush and ent.AntiPush.Collision then
		ent:SetCollisionGroup(ent.AntiPush.Collision)
	end
end)

hook.Add("OnPhysgunFreeze", "NoPushPhysgunFreeze", function(_, phys, ent, ply)
	if (IsValid(ply) and IsValid(ent)) and ent.AntiPush and ent.AntiPush.Collision then
		ent:SetCollisionGroup(ent.AntiPush.Collision)
	end
end)

  function antiPropDamage (victim, attacker)
    if (attacker:IsValid()) then
        if (attacker:GetClass() == "prop_physics" or attacker:IsWorld() or attacker:GetClass() == "prop_vehicle_jeep") then
            owner = attacker:CPPIGetOwner():Nick()
	    prop = attacker:GetPhysicsObject()
            prop:EnableMotion(false)
            attacker:SetColor( Color( 255, 0, 0, 255 ) )
			for k, v in pairs( player.GetAll() ) do
				if ULib.ucl.query( v, seeasayAccess ) then
					v:PrintColor( Color( 255, 0, 0 ), "Prop Protection ", Color( 255, 255, 255 ), "| ", victim:Nick(), " was almost prop-killed by ", owner, "!" )
				end
			end
			
            return false
        else
            if (attacker:IsPlayer()) then
                if (attacker:InVehicle()) then
                    owner = attacker:CPPIGetOwner()
                    attacker:EnableMotion(false)
                    attacker:SetColor( Color( 255, 0, 0, 255 ) )
                    return false
                end
            else
                return true
            end
        end
    end
  end

  hook.Add("PlayerShouldTakeDamage", "nopropdamage", antiPropDamage)

end
