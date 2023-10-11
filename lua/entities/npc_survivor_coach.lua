if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Coach"
ENT.WeaponModel = "models/w_models/weapons/w_autoshot_m4super.mdl"

list.Set( "NPC", "coach", {
	Name = "Coach",
	Class = "npc_survivor_coach",
	Category = "Left 4 Dead 2 - Survivors"
})
 