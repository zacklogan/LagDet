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

  hook.Add("ShouldCollide","ShouldCollideTest",function(ent1,ent2)
    if ent1:IsPlayer() and !ent2:IsPlayer() then
      if ent2.ATOwner!=ent1 and ent2.isheld then
	      return false
	    end
    elseif ent2:IsPlayer() and !ent1:IsPlayer() then
	    if ent1.ATOwner!=ent2 and ent1.isheld then
	      return false
	    end
    end
  end)

  hook.Add("PhysgunPickup","PropPush",function(ply,ent)
    ent.isheld=true
  end)

  hook.Add("PhysgunDrop","PropPush",function(ply,ent)
    ent.isheld=false
  end)

  function antiPropDamage (victim, attacker)
    if (attacker:IsValid()) then
        if (attacker:GetClass() == "prop_physics" or attacker:IsWorld() or attacker:GetClass() == "prop_vehicle_jeep") then
            owner = attacker:GetCPPIOwner()
            attacker:EnableMotion(false)
            attacker:SetColor( Color( 255, 0, 0, 255 ) )
            return false
        else
            if (attacker:IsPlayer()) then
                if (attacker:InVehicle()) then
                    owner = attacker:GetCPPIOwner()
                    attacker:EnableMotion(false)
                    attacker:SetColor( Color( 255, 0, 0, 255 ) )
                    return false
                end
            else
                return true
            end
        end
    end
    if (owner != nil) then
      for k, v in pairs( player.GetAll() ) do
	      if ucl.query(v, "ulx asay", false) then
	        v:PrintColor( Color( 255, 0, 0 ), "Prop Protection ", Color( 255, 255, 255 ), "| ", victim:Nick(), " was almost prop-killed by ", owner, "!" )
	      end
      end
    end
  end

  hook.Add("PlayerShouldTakeDamage", "nopropdamage", antiPropDamage)

end
