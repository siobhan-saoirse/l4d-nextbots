if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Gambler"
ENT.WeaponModel = "models/w_models/weapons/w_rifle_m16a2.mdl"

list.Set( "NPC", "nick", {
	Name = "Nick",
	Class = "npc_survivor_nick",
	Category = "Left 4 Dead 2 - Survivors"
})
