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
