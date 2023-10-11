if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_survivor_ellis"
ENT.Type			= "nextbot"
ENT.SurvivorName			= "Player.Teengirl"
ENT.WeaponModel = "models/w_models/weapons/w_smg_uzi.mdl"

list.Set( "NPC", "zoey", {
	Name = "Zoey",
	Class = "npc_survivor_zoey",
	Category = "Left 4 Dead - Survivors"
})
  