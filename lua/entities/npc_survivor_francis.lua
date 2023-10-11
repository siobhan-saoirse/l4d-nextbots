if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Player.Biker"
ENT.WeaponModel = "models/w_models/weapons/w_autoshot_m4super.mdl"

list.Set( "NPC", "francis", {
	Name = "Francis",
	Class = "npc_survivor_francis",
	Category = "Left 4 Dead - Survivors"
})
 