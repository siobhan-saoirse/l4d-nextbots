if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Player.Manager"
ENT.WeaponModel = "models/w_models/weapons/w_rifle_m16a2.mdl"

list.Set( "NPC", "louis", {
	Name = "Louis",
	Class = "npc_survivor_louis",
	Category = "Left 4 Dead - Survivors"
})
  