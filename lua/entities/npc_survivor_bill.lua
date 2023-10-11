if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Player.Namvet"
ENT.WeaponModel = "models/w_models/weapons/w_rifle_m16a2.mdl"

list.Set( "NPC", "bill", {
	Name = "Bill",
	Class = "npc_survivor_bill",
	Category = "Left 4 Dead - Survivors"
})
 