if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
ENT.Base 			= "npc_tank"
ENT.Type			= "nextbot"
ENT.IsVersus = true


list.Set( "NPC", "tank_vs", {
	Name = "The Tank (versus)",
	Class = "npc_tank_vs",
	Category = "Left 4 Dead 2"
})