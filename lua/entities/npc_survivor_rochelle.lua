if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Producer"
ENT.WeaponModel = "models/w_models/weapons/w_smg_uzi.mdl"

list.Set( "NPC", "rochelle", {
	Name = "Rochelle",
	Class = "npc_survivor_rochelle",
	Category = "Left 4 Dead 2 - Survivors"
})
 