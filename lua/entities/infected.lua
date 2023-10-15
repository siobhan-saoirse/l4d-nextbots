if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
if CLIENT then
	language.Add("infected", "Infected")
end
local function getAllInfected()
	local npcs = {}
	if (math.random(1,25) == 1) then
		for k,v in ipairs(ents.GetAll()) do
			if (v:GetClass() == "infected") then
				if (v:Health() > 0) then
					table.insert(npcs, v)
				end
			end
		end
	end
	return npcs
end
local function lookForNextPlayer(ply)
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), 1300 )) do
			
			if (engine.ActiveGamemode() == "teamfortress") then
				if (v:IsTFPlayer() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex()) then
					if (v:Health() > 1) then
						table.insert(npcs, v)
					end
				end
			else
				if ((v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() || v:IsNPC() || string.find(v:GetClass(),"npc_survivor")) and v:GetClass() != "infected" and v:EntIndex() != ply:EntIndex()) then
					if (v:Health() > 1) then
						table.insert(npcs, v)
					end
				end
			end
		end
	end
	return npcs
end

local function isbeingMobbed(ply)
	local npcs = {}
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), 200 )) do
			if (v:GetClass() == "infected") then
				table.insert(npcs,v)
			end
		end
	return table.Count(npcs) > 10  
end
local function nearestNPC(ply)
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), 500 )) do
			if (v:IsNPC() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex()) then
				if (v:Health() > 0) then
					table.insert(npcs, v)
				end
			end
		end
	end
	return npcs
end
local function nearestDoor(ply)
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(),120)) do
			if ((v:GetClass() == "prop_door_rotating" or v:GetClass() == "prop_physics")  and v:GetPos():Distance(ply:GetPos()) < 70) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end

local function nearestPipebomb(ply)
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(),2600)) do
			
			if (engine.ActiveGamemode() == "teamfortress") then
				if ((!string.find(v:GetClass(),"weapon_") and (string.find(v:GetClass(),"grenade") or string.find(v:GetClass(),"pipe") or string.find(v:GetClass(),"bomb"))) or (v:IsTFPlayer() and v:EntIndex() != ply:EntIndex() and (v:HasPlayerState(PLAYERSTATE_JARATED) or v:HasPlayerState(PLAYERSTATE_PUKEDON)))) then
					table.insert(npcs, v)
				end
			else
				if (((!string.find(v:GetClass(),"weapon_") and (string.find(v:GetClass(),"grenade") or string.find(v:GetClass(),"pipe") or string.find(v:GetClass(),"bomb")))) or ((v:IsPlayer() or v:IsNPC()) and v.AttractedToInfected and !v:IsFlagSet(FL_NOTARGET))) then
					table.insert(npcs, v)
				end
			end
		end
	end
	return npcs
end


ENT.Base 			= "base_nextbot"
ENT.Type			= "nextbot"
ENT.Name			= "Infected"
ENT.Spawnable		= false
ENT.IsAL4DZombie = true
ENT.AttackDelay = 50
ENT.AttackDamage = 3
ENT.AttackRange = 50
ENT.AttackRange2 = 190
ENT.AutomaticFrameAdvance = true
ENT.HaventLandedYet = false
ENT.Walking = false
ENT.IsRightArmCutOff = false
ENT.IsLeftArmCutOff = false
local modeltbl = {
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male01.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male02.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_male_baggagehandler_02.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_male_tanktop_jeans.mdl",
	"models/infected/common_male_tanktop_jeans_rain.mdl",
	"models/infected/common_male_tanktop_jeans_swamp.mdl",
	"models/infected/common_male_tanktop_overalls.mdl",
	"models/infected/common_male_tanktop_overalls_rain.mdl",
	"models/infected/common_male_tanktop_overalls_swamp.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_male_baggagehandler_02.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_male_tanktop_jeans.mdl",
	"models/infected/common_male_tanktop_jeans_rain.mdl",
	"models/infected/common_male_tanktop_jeans_swamp.mdl",
	"models/infected/common_male_tanktop_overalls.mdl",
	"models/infected/common_male_tanktop_overalls_rain.mdl",
	"models/infected/common_male_tanktop_overalls_swamp.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_male_baggagehandler_02.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_male_tanktop_jeans.mdl",
	"models/infected/common_male_tanktop_jeans_rain.mdl",
	"models/infected/common_male_tanktop_jeans_swamp.mdl",
	"models/infected/common_male_tanktop_overalls.mdl",
	"models/infected/common_male_tanktop_overalls_rain.mdl",
	"models/infected/common_male_tanktop_overalls_swamp.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_male_baggagehandler_02.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_male_tanktop_jeans.mdl",
	"models/infected/common_male_tanktop_jeans_rain.mdl",
	"models/infected/common_male_tanktop_jeans_swamp.mdl",
	"models/infected/common_male_tanktop_overalls.mdl",
	"models/infected/common_male_tanktop_overalls_rain.mdl",
	"models/infected/common_male_tanktop_overalls_swamp.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_male_baggagehandler_02.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_male_tanktop_jeans.mdl",
	"models/infected/common_male_tanktop_jeans_rain.mdl",
	"models/infected/common_male_tanktop_jeans_swamp.mdl",
	"models/infected/common_male_tanktop_overalls.mdl",
	"models/infected/common_male_tanktop_overalls_rain.mdl",
	"models/infected/common_male_tanktop_overalls_swamp.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_baggagehandler_01.mdl",
	"models/infected/common_male_baggagehandler_02.mdl",
	"models/infected/common_male_biker.mdl",
	"models/infected/common_male_tanktop_jeans.mdl",
	"models/infected/common_male_tanktop_jeans_rain.mdl",
	"models/infected/common_male_tanktop_jeans_swamp.mdl",
	"models/infected/common_male_tanktop_overalls.mdl",
	"models/infected/common_male_tanktop_overalls_rain.mdl",
	"models/infected/common_male_tanktop_overalls_swamp.mdl",
	"models/infected/common_male_tshirt_cargos_swamp.mdl",
	"models/infected/common_male_tshirt_cargos.mdl",
	"models/infected/common_male_mud.mdl",
	"models/infected/common_male_mud.mdl",
	"models/infected/common_male_mud.mdl",
	"models/infected/common_male_mud.mdl",
	"models/infected/common_male_mud_l4d1.mdl",
	"models/infected/common_male_mud_l4d1.mdl",
	"models/infected/common_male_mud_l4d1.mdl",
	"models/infected/common_male_mud_l4d1.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01_suit.mdl",
	"models/infected/common_female_formal.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_female_tanktop_jeans.mdl",
	"models/infected/common_female_tshirt_skirt.mdl",
	"models/infected/common_female_baggagehandler_01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01_suit.mdl",
	"models/infected/common_female_formal.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_female_tanktop_jeans.mdl",
	"models/infected/common_female_tshirt_skirt.mdl",
	"models/infected/common_female_baggagehandler_01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01_suit.mdl",
	"models/infected/common_female_formal.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_female_tanktop_jeans.mdl",
	"models/infected/common_female_tshirt_skirt.mdl",
	"models/infected/common_female_baggagehandler_01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01_suit.mdl",
	"models/infected/common_female_formal.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_female_tanktop_jeans.mdl",
	"models/infected/common_female_tshirt_skirt.mdl",
	"models/infected/common_female_baggagehandler_01.mdl",
	"models/infected/common_female01.mdl",
	"models/infected/common_female01_suit.mdl",
	"models/infected/common_female_formal.mdl",
	"models/infected/common_female_nurse01.mdl",
	"models/infected/common_female_rural01.mdl",
	"models/infected/common_female_tanktop_jeans.mdl",
	"models/infected/common_female_tshirt_skirt.mdl",
	"models/infected/common_female_baggagehandler_01.mdl",
	"models/infected/common_male_parachutist.mdl",
	"models/infected/common_male_parachutist.mdl",
	"models/infected/common_male_ceda.mdl",
	"models/infected/common_male_ceda.mdl",
	"models/infected/common_male_ceda.mdl",
	"models/infected/common_male_riot.mdl",
	"models/infected/common_male_riot.mdl",
	"models/infected/common_male_riot.mdl",
	"models/infected/common_male_riot.mdl",
	"models/infected/common_male_formal.mdl",
	"models/infected/common_male_jimmy.mdl",
	--"models/infected/common_male_ceda_l4d1.mdl",
	"models/infected/common_male_dressshirt_jeans.mdl",
	--"models/infected/common_male_fallen_survivor_l4d1.mdl",
	"models/infected/common_male_fallen_survivor.mdl",
	--"models/infected/common_male_riot_l4d1.mdl",
	"models/infected/common_male_mud.mdl",
	"models/infected/common_male_mud_l4d1.mdl",
	"models/infected/common_male_riot.mdl",
	"models/infected/common_male_roadcrew.mdl",
	"models/infected/common_male_roadcrew_rain.mdl",
	"models/infected/common_patient_male01_l4d2.mdl",
	"models/infected/common_morph_test.mdl",
	"models/infected/common_male_pilot.mdl",
	"models/infected/common_male_rural01.mdl",
	"models/infected/common_male_suit.mdl",
	"models/infected/common_military_male01.mdl",
	"models/infected/common_patient_male01.mdl", 
	"models/infected/common_patient_male01_l4d2.mdl",
	"models/infected/common_police_male01.mdl",
	"models/infected/common_surgeon_male01.mdl",
	"models/infected/common_tsaagent_male01.mdl",
	"models/infected/common_male_suit.mdl",
	"models/infected/common_test.mdl"
}

hook.Remove("EntityEmitSound","InfectedHearSound")
hook.Add("EntityEmitSound","InfectedHearSound",function(snd)
	if (IsValid(snd.Entity)) then
		if IsValid(snd.Entity) and snd.Entity:GetModel() and string.StartWith(snd.Entity:GetModel(), "models/infected/common_") and string.find(snd.SoundName, "step") then
			snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
			snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
			snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
			snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
			snd.SoundName = string.Replace(snd.SoundName, "snow5", "snow1")
			snd.SoundName = string.Replace(snd.SoundName, "snow6", "snow2")
			snd.Channel = CHAN_BODY
			local speed = snd.Entity:GetVelocity():Length()
			local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
			snd.Volume = 0.5
			--[[
	if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
				local pos = snd.Entity:GetPos()
				if (snd.Pos) then
					pos = snd.Pos
				end
				if (snd.Channel == CHAN_BODY) then
					if (math.random(1,6) != 1) then
						snd.Channel = CHAN_STATIC
						return true
					end
				end
			end]]
			if (string.find(snd.Entity:GetModel(),"clown")) then
				if (snd.Entity:WaterLevel() < 1) then
					snd.SoundName = "player/footsteps/clown/concrete"..math.random(1,8)..".wav"
					snd.Volume = 1
					for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),1200)) do
						if (v:GetClass() == "infected") then
							if (IsValid(snd.Entity:GetEnemy())) then 
								v:SetEnemy(snd.Entity:GetEnemy())
							end
						end
					end
				elseif (snd.Entity:WaterLevel() < 2) then
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
					snd.Volume = 1
				else
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
					snd.Volume = 1
				end
			elseif (string.find(snd.Entity:GetModel(),"mud")) then
				if (snd.Entity:WaterLevel() < 1) then  
					snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/run/")
					snd.Volume = 1
				elseif (snd.Entity:WaterLevel() < 2) then
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
					snd.Volume = 1
				else
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
					snd.Volume = 1
				end
			elseif (string.find(snd.Entity:GetModel(),"riot")) then
				if (snd.Entity:GetSequenceActivity(snd.Entity:GetSequence()) != snd.Entity:GetSequenceActivity(snd.Entity:LookupSequence("run_01"))) then

					snd.SoundName = table.Random(
						{
							"player/footsteps/infected/walk/dirt1.wav",
							"player/footsteps/infected/walk/dirt2.wav",
							"player/footsteps/infected/walk/dirt3.wav",
							"player/footsteps/infected/walk/dirt4.wav",
							"player/footsteps/survivor/walk/tile1.wav",
							"player/footsteps/survivor/walk/tile2.wav",
							"player/footsteps/survivor/walk/tile3.wav",
							"player/footsteps/survivor/walk/tile4.wav",
						}
					)
					snd.Volume = 0.85
				else
					snd.SoundName = table.Random(
						{
							"player/footsteps/infected/run/dirt1.wav",
							"player/footsteps/infected/run/dirt2.wav",
							"player/footsteps/infected/run/dirt3.wav",
							"player/footsteps/infected/run/dirt4.wav",
							"player/footsteps/survivor/run/tile1.wav",
							"player/footsteps/survivor/run/tile2.wav",
							"player/footsteps/survivor/run/tile3.wav",
							"player/footsteps/survivor/run/tile4.wav",
						}
					)
					snd.Volume = 0.6
				end
			else
				if (snd.Entity:WaterLevel() < 1) then
						
					if (snd.Entity:GetSequenceActivity(snd.Entity:GetSequence()) != snd.Entity:GetSequenceActivity(snd.Entity:LookupSequence("run_01"))) then
						snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
						snd.Volume = 0.85
					else
						snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
						snd.Volume = 0.6
					end

				elseif (snd.Entity:WaterLevel() < 2) then
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/infected/run/wade"..math.random(1,4)..".wav")
					snd.Volume = 1
				else
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/infected/run/wade"..math.random(1,4)..".wav")
					snd.Volume = 1
				end
			end
			snd.Pitch = math.random(95,105)
			return true
		end
			if ((snd.Entity:IsPlayer() || snd.Entity:IsNPC()) and !snd.Entity:IsNextBot() and snd.Entity:GetClass() != "infected") then
				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),300)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready and !v.ContinueRunning and !v:IsOnFire() and !snd.Entity:IsFlagSet(FL_NOTARGET)) then
						if (IsValid(v) and v:IsPlayer() and (v:IsFlagSet(FL_NOTARGET) or GetConVar("ai_ignoreplayers"):GetBool())) then return end
						v:SetEnemy(snd.Entity)
						--v:EmitSound("L4D_Zombie.RageAtVictim")
		
						if SERVER then
							--[[
	local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							--v:AddGestureSequence(anim,true)]]
						end
		
						timer.Stop("IdleExpression"..v:EntIndex())
						timer.Stop("AngryExpression"..v:EntIndex())
						timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
							
							if SERVER then
								local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
								--v:AddGestureSequence(anim,true)
							end
		
							timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim) - 0.2)
						end)
						if SERVER then
							for _,npc in ipairs(ents.GetAll()) do
								if npc:IsNPC() then
									npc:AddEntityRelationship(v,D_HT,99)
								end
							end
						end
					end
				end
			end
	end
end)
function ENT:IsNPC()
	return false
end
-- remade this in lua so we can finally ignore the controller's bot
-- for some reason it's not really possible to overwrite IsAbleToSee
local function PointWithinViewAngle(pos, targetpos, lookdir, fov)
	pos = targetpos - pos
	local diff = lookdir:Dot(pos)
	if diff < 0 then return false end
	local len = pos:LengthSqr()
	return diff * diff > len * fov * fov
end

function ENT:InFOV(pos, fov)
	local owner = self:GetOwner()

	if IsEntity(pos) then
		-- we must check eyepos and worldspacecenter
		-- maybe in the future add more points

		if PointWithinViewAngle(owner:EyePos(), pos:WorldSpaceCenter(), owner:GetAimVector(), fov) then
			return true
		end

		return PointWithinViewAngle(owner:EyePos(), pos:EyePos(), owner:GetAimVector(), fov)
	else
		return PointWithinViewAngle(owner:EyePos(), pos, owner:GetAimVector(), fov)
	end
end

function ENT:CanSee(ply, fov)
	if ply:GetPos():DistToSqr(self:GetPos()) > self:GetMaxVisionRange() * self:GetMaxVisionRange() then
		return false
	end

	-- TODO: check fog farz and compare with distance

	-- half fov or something
	-- probably should move this to a variable
	fov = fov or true

	if fov and !self:InFOV(ply, math.cos(0.5 * (self:GetFOV() or 90) * math.pi / 180)) then
		return false
	end

	-- TODO: we really should check worldspacecenter too
	local owner = self:GetOwner()
	return util.QuickTrace(owner:EyePos(), ply:EyePos() - owner:EyePos(), {owner, self}).Entity == ply
end

function ENT:Shove(anim)
	self:EmitSound("L4D_Zombie.Shoved")
end

-- these 6 funcs are not mine, by dragoteryx

-- Functions --

function ENT:SelectRandomSequence(anim)
	return self:SelectWeightedSequenceSeeded(anim, math.random(0, 255))
end

function ENT:PlaySequenceAndMove(seq, options, callback)
	if isstring(seq) then seq = self:LookupSequence(seq)
	elseif not isnumber(seq) then return end
	if seq == -1 then return end
	if isnumber(options) then options = {rate = options}
	elseif not istable(options) then options = {} end
	if options.gravity == nil then options.gravity = true end
	if options.collisions == nil then options.collisions = true end
	local previousCycle = 0
	local previousPos = self:GetPos()  
	self.loco:SetDesiredSpeed( self:GetSequenceGroundSpeed( seq ) )
	local res = self:PlaySequenceAndWait2(seq, options.rate, function(self, cycle)
		local success, vec, angles = self:GetSequenceMovement(seq, previousCycle, cycle)
		if success then
			vec = Vector(vec.x, vec.y, vec.z)
			vec:Rotate(self:GetAngles() + angles)	
			self:SetAngles(self:LocalToWorldAngles(angles))
			if (self:IsInWorld() and self:IsOnGround()) then
				previousPos = self:GetPos() + vec*self:GetModelScale()
				self:SetPos(previousPos)
			end
		end
		previousCycle = cycle
		if isfunction(callback) then return callback(self, cycle) end
	end)
	if not options.gravity then
		self:SetPos(previousPos)
		self:SetVelocity(Vector(0, 0, 0))
	end
	return res
end

function ENT:TraceHull(vec,data)

	if not isvector(vec) then vec = Vector(0, 0, 0) end
	local bound1, bound2 = self:GetCollisionBounds()
	local scale = self:GetModelScale()
	if scale > 1 then
		bound1 = bound1 * (1 + 0.01 * scale)
		bound2 = bound2 * (1 + 0.01 * scale)
	end
	if bound1.z < bound2.z then
		local temp = bound1
		bound1 = bound2
		bound2 = temp
	end
	local trdata = {}
	data = data or {}
	if self.IsDrGNextbot and data.step then
		bound2.z = self.loco:GetStepHeight()
	end
	trdata.start = data.start or self:GetPos()
	trdata.endpos = data.endpos or trdata.start + vec
	trdata.collisiongroup = data.collisiongroup or self:GetCollisionGroup()
	if self.IsDrGNextbot then
		if SERVER then trdata.mask = data.mask or self:GetSolidMask() end
		trdata.filter = data.filter or {self, self:GetWeapon(), self:GetPossessor()}
	else trdata.filter = data.filter or self end
	trdata.maxs = data.maxs or bound1
	trdata.mins = data.mins or bound2
	return util.TraceHull(trdata)

end
function ENT:YieldCoroutine(interrompt)
	if interrompt then
		repeat
			coroutine.yield()
		until not GetConVar("ai_disabled"):GetBool()
	else
		coroutine.yield()
	end
end

function ENT:GetMovement(ignoreZ)
	local dir = self:GetVelocity()
	if ignoreZ then dir.z = 0 end
	return (self:GetAngles()-dir:Angle()):Forward()
end

function ENT:DirectPoseParametersAt(pos, pitch, yaw, center)
	if not isstring(yaw) then
		return self:DirectPoseParametersAt(pos, pitch.."_pitch", pitch.."_yaw", yaw)
	elseif isentity(pos) then pos = pos:WorldSpaceCenter() end
	if isvector(pos) then
		center = center or self:WorldSpaceCenter()
		local angle = (pos - center):Angle()
		self:SetPoseParameter(pitch, math.AngleDifference(angle.p, self:GetAngles().p))
		self:SetPoseParameter(yaw, math.AngleDifference(angle.y, self:GetAngles().y))
	else
		self:SetPoseParameter(pitch, 0)
		self:SetPoseParameter(yaw, 0)
	end
end

function ENT:PlaySequenceAndWait2(seq, rate, callback)
	if isstring(seq) then seq = self:LookupSequence(seq)
	elseif not isnumber(seq) then return end
	if seq == -1 then return end
	local current = self:GetSequence()
	self.PlayingSequence2 = true
	self:SetCycle(0)
	self:ResetSequence(seq)
	self:ResetSequenceInfo()
	self:SetPlaybackRate(1)
	local now = CurTime()
	self.lastCycle = -1
	self.callback = callback
	timer.Create("MoveAgain"..self:EntIndex(), self:SequenceDuration(seq) - 0.2, 1,function()
		self.PlayingSequence2 = false 
	end)
end
function ENT:PlayActivityAndMove(act, options, callback)
	if (act == -1) then ErrorNoHalt("What the FUCK why is there no ACT for this sequence???") return end
	local seq = self:SelectRandomSequence(act)
	self:StartActivity(act)
	return self:PlaySequenceAndMove(seq, options, callback)
end

function ENT:Initialize()

	if SERVER then
		if (!self.DontReplaceModel) then
			local rnd = table.Random(modeltbl)
			self:SetModel( rnd )
			if (string.find(rnd,"_male")) then
				self.gender = "male"
			elseif (string.find(rnd,"_female")) then
				self.gender = "female"
			else
				self.gender = "male"
			end
			if (string.find(self:GetModel(),"riot")) then
				
				if SERVER then
					local axe = ents.Create("gmod_button")
					axe:SetModel("models/infected/cim_riot_faceplate.mdl")
					axe:SetPos(self:GetPos())
					axe:SetAngles(self:GetAngles())
					axe:SetParent(self)
					axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self:SetNWEntity("Axe",axe)
				end

			elseif (string.find(self:GetModel(),"ceda")) then
				
				if SERVER then
					local axe = ents.Create("gmod_button")
					axe:SetModel("models/infected/cim_faceplate.mdl")
					axe:SetPos(self:GetPos())
					axe:SetAngles(self:GetAngles())
					axe:SetParent(self)
					axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self:SetNWEntity("Axe",axe)
				end

			end
		end
	end
	self.LoseTargetDist	= 25000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 200	-- How far to search for enemies
	if (string.find(self:GetModel(),"jimmy")) then
		self:SetHealth(200) 
	else
		self:SetHealth(30) 
	end
	self:AddEffects(EF_NOINTERP)
	if SERVER then
		--[[
		if (math.random(1,4) == 1) then
			self:SetColor(Color(255,255,0))
			self:SetRenderMode( RENDERMODE_TRANSALPHADD )
		elseif (math.random(1,6) == 1) then
			self:SetColor(Color(128,128,0))
			self:SetRenderMode( RENDERMODE_TRANSALPHADD )
		end]]
		self:SetTrigger(true)
		self:SetFOV(54)
		
		if (string.find(self:GetModel(),"riot")) then

			self:SetBloodColor(BLOOD_COLOR_MECH)

		else
			self:SetBloodColor(BLOOD_COLOR_RED)
		end
		self:SetCollisionGroup(COLLISION_GROUP_NPC)
		self:AddFlags(FL_OBJECT)
		self:AddFlags(FL_NPC)
		self:SetSkin(math.random(0,self:SkinCount()-1)) 
		if (table.Count(getAllInfected()) > 30) then
			self:Remove()
		end
		if SERVER then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					
			if (v:Classify() == CLASS_ZOMBIE) then
				v:AddEntityRelationship(self,D_LI,99)
			else
				v:AddEntityRelationship(self,D_HT,99)
			end
				end
			end
		end
		--self:SetBodygroup(0,math.random(1,2))
		--self:SetBodygroup(1,math.random(1,2))
		
		local mad = self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))
		self:StartActivity( mad )
		timer.Simple(0.1, function()
		
			self.Ready = true

		end)
		timer.Create("IdleExpression"..self:EntIndex(), 0, 0, function()
			if (self:GetEnemy() != nil) then

				local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
				if SERVER then
					self:AddGestureSequence(anim,true)
				end
		
				
				timer.Adjust("IdleExpression"..self:EntIndex(),self:SequenceDuration(anim) - 0.2)

			else
				
				local anim = self:LookupSequence("exp_idle_0"..math.random(1,6))
				if SERVER then
					self:AddGestureSequence(anim,true)
				end
		
				
				timer.Adjust("IdleExpression"..self:EntIndex(),self:SequenceDuration(anim) - 0.2)
			end
		end)
		local anim = self:LookupSequence("idlenoise")
		if SERVER then
			self:AddGestureSequence(anim,false)
		end
	end	
	timer.Create("PlaySomeIdleSounds"..self:EntIndex(), math.random(2,4), 0, function()
	
		if (self.Ready) then 
			if (self:Health() > 0 and !GetConVar("ai_disabled"):GetBool()) then
				if (IsValid(self:GetEnemy())) then
						if (!self.PlayingSequence) then
							self:EmitSound(table.Random(
								{
									"npc/infected/action/rageAt/rage_at_victim25.wav",
									"npc/infected/action/rageAt/rage_at_victim35.wav",
									"npc/infected/action/rageAt/rage_at_victim02.wav",
									"npc/infected/action/rageAt/rage_at_victim34.wav",
									"npc/infected/action/rageAt/rage_at_victim26.wav",
									"npc/infected/action/rageAt/rage_at_victim01.wav",
									"npc/infected/action/rageAt/rage_at_victim22.wav",
									"npc/infected/action/rageAt/rage_at_victim21.wav",
									"npc/infected/action/rageAt/snarl_4.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim20.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim21.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim22.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim23.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim24.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim25.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim26.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim27.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim28.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim29.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim30.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim31.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim32.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim33.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim34.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim35.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim36.wav",
									"npc/infected/action/rageAt/"..self.gender.."/rage_at_victim37.wav",					
									"npc/infected/action/rage/"..self.gender.."/rage_50.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_51.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_52.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_53.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_54.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_55.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_56.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_57.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_58.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_59.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_60.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_61.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_62.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_64.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_65.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_66.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_67.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_68.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_69.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_70.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_71.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_72.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_73.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_74.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_75.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_76.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_77.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_78.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_79.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_80.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_81.wav",
									"npc/infected/action/rage/"..self.gender.."/rage_82.wav"
								}),75,math.random(95,105),1,CHAN_VOICE)
						end
				else
						self:EmitSound(table.Random({"L4D_Zombie.Wander","L4D_Zombie.Sleeping"}))
				end
			end
		end

	end)
end

function ENT:HandleStuck()
	--
	-- Clear the stuck status
	--
	
	if (IsValid(self:GetEnemy())) then
		
		if (!self.PlayingSequence2 and !self.PlayingSequence3) then
			self:SetCycle(0)
			self:PlayActivityAndMove(self:GetSequenceActivity(self:LookupSequence("Idle_UnableToReachTarget_01a")))
		end
		self.loco:ClearStuck()
		
	else
		local dmginfo = DamageInfo()
		dmginfo:SetAttacker(self)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamageType(DMG_CRUSH)
		dmginfo:SetDamage(self:Health())
		self:OnKilled(dmginfo)
		self.loco:ClearStuck()
	end
end


function ENT:OnRemove()
	timer.Stop("IdleExpression"..self:EntIndex())
	timer.Stop("AngryExpression"..self:EntIndex())
							if (self.MobbedMusic != nil) then
								self.MobbedMusic:FadeOut(2)
							end
	if (IsValid(self.bullseye)) then
		self.bullseye:Remove()
	end
end

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	if (ent != nil and ent:IsNextBot() and !string.find(ent:GetClass(),"npc_survivor")) then self.Grenade = nil self.Enemy = nil return false end
	if (IsValid(self.Enemy)) then
		self:GetEnemy():StopSound("Event.Mobbed")
		self.Enemy.IsMobbed = false
	end
	self.Enemy = ent
	self.Pounced = false
	timer.Stop("HunterPounce"..self:EntIndex())
	timer.Stop("HunterPounceShred"..self:EntIndex())
	if (ent != nil) then
		self.Idling = false
	end
	for k,v in ipairs(nearestNPC(self)) do
		if v:IsNPC() then
			if (v:Classify() == CLASS_ZOMBIE) then
				v:AddEntityRelationship(self,D_LI,99)
			else
				v:AddEntityRelationship(self,D_HT,99)
			end
		end
	end
end
function ENT:GetEnemy()
	return self.Grenade or self.Enemy
end

----------------------------------------------------
-- ENT:HaveEnemy()
-- Returns true if we have a enemy
----------------------------------------------------
function ENT:HaveEnemy()
	-- If our current enemy is valid
	if (GetConVar("ai_disabled"):GetBool()) then return false end 
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) ) then
		-- If the enemy is too far
		local ent = self:GetEnemy()
		if (ent:IsPlayer() and (ent:IsFlagSet(FL_NOTARGET) or GetConVar("ai_ignoreplayers"):GetBool())) then return self:FindEnemy() end
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif (engine.ActiveGamemode() == "teamfortress") then
			if ( self:GetEnemy():IsTFPlayer() and (GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_SPECTATOR or GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_FRIENDLY or self:GetEnemy():Health() < 0 or self:GetEnemy():IsFlagSet(FL_NOTARGET)) ) then
				return self:FindEnemy()
			end	 
		elseif (self:GetEnemy():Health() < 0 or self:GetEnemy():IsFlagSet(FL_NOTARGET) or (self:GetEnemy():IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool())) then
			return self:FindEnemy()
		end
		-- The enemy is neither too far nor too dead so we can return true
		return true
	else
		-- The enemy isn't valid so lets look for a new onethen
		if (self:IsOnGround() and self.Ready) then
			if (self:GetEnemy() != nil) then
				if (string.find(self:GetModel(),"mud")) then

					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation

				else
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
				end
			else
				--self:SetCycle(0)
				if (!self.Idling) then
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) )
					self.Idling = true
				end
			end
		end
		return self:FindEnemy()
	end
end

----------------------------------------------------
-- ENT:FindEnemy()
-- Returns true and sets our enemy if we find one
----------------------------------------------------
function ENT:FindEnemy()
	if not self.Ready then return false end
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = lookForNextPlayer(self)
	-- Here we loop through every entity the above search finds and see if it's the one we want
		for k,v in ipairs( _ents ) do
			if (engine.ActiveGamemode() == "teamfortress") then
				if ( ( v:IsPlayer() or v:IsNPC()) and !v:IsFriendly(self) and GAMEMODE:EntityTeam(v) != TEAM_SPECTATOR and GAMEMODE:EntityTeam(v) != TEAM_FRIENDLY and v:Health() > 1 and !v:IsFlagSet(FL_NOTARGET) ) then
					-- We found one so lets set it as our enemy and return true
					self:SetEnemy(v)
					--self:EmitSound("L4D_Zombie.RageAtVictim")
					if (v:IsNPC() and v:Classify() != CLASS_ZOMBIE) then
						if (!IsValid(v:GetEnemy())) then
							v:SetEnemy(self)
							
							if (v:Classify() == CLASS_ZOMBIE) then
								v:AddEntityRelationship(self,D_LI,99)
							else
								v:AddEntityRelationship(self,D_HT,99)
							end
							
						end
					end

					if SERVER then
						for _,npc in ipairs(ents.FindByClass("npc_*")) do
							if (npc:Classify() != CLASS_ZOMBIE) then
								npc:SetEnemy(self)
							end
						end
						local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
						self:AddGestureSequence(anim,true)
					end

					timer.Stop("IdleExpression"..self:EntIndex())
					timer.Stop("AngryExpression"..self:EntIndex())
					timer.Create("AngryExpression"..self:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
							self:AddGestureSequence(anim,true)
						end

						timer.Adjust("AngryExpression"..self:EntIndex(),self:SequenceDuration(anim) - 0.2)
					end)
					return true
				end
			else

				if ( ( v:IsPlayer() or v:IsNPC()) and !v:IsNextBot() and v:GetClass() != "infected" and v:Health() > 0 and !v:IsFlagSet(FL_NOTARGET) ) then
					-- We found one so lets set it as our enemy and return true
					self:SetEnemy(v)
					--self:EmitSound("L4D_Zombie.RageAtVictim")
					if (v:IsNPC() and v:Classify() != CLASS_ZOMBIE) then
						if (!IsValid(v:GetEnemy())) then
							v:SetEnemy(self)
							
							if (v:Classify() == CLASS_ZOMBIE) then
								v:AddEntityRelationship(self,D_LI,99)
							else
								v:AddEntityRelationship(self,D_HT,99)
							end
							
						end
					end

					if SERVER then
						local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
						self:AddGestureSequence(anim,true)
					end

					timer.Stop("IdleExpression"..self:EntIndex())
					timer.Stop("AngryExpression"..self:EntIndex())
					timer.Create("AngryExpression"..self:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
							self:AddGestureSequence(anim,true)
						end

						timer.Adjust("AngryExpression"..self:EntIndex(),self:SequenceDuration(anim) - 0.2)
					end)
					return true
				end
			end
		end	
	
	-- We found nothing so we will set our enemy as nil (nothing) and return false
	self:SetEnemy(nil)
	return false
end
-- Open the area portal linked to this door entity
local function OpenLinkedAreaPortal(ent)
	local name = ent:GetName()
	if not name or name == "" then return end
	
	for _,v in pairs(ents.FindByClass("func_areaportal")) do
		if v.TargetDoorName == name then
			v:Fire("Open")
		end
	end
end
function ENT:HandleAnimEvent( event, eventTime, cycle, type, options )
	if (event == 3001) then
		if (IsValid(self.Door)) then

			self.loco:ClearStuck() 
			self:EmitSound(
				"Doors.Wood.Pound1",
				85, math.random(90,105)
			)
			debugoverlay.Text( self:GetPos(), "Breaking down door #"..self.Door:EntIndex().."!", 1.5,false )
			debugoverlay.Box( self.Door:GetPos(), self.Door:OBBMins(), self.Door:OBBMaxs(), 1.5, Color( 128, 0, 0, 128) )
			--self:SetCollisionGroup( )
			if (math.random(1,6) == 1) then
				if (self.Door:GetClass() != "prop_physics") then
					debugoverlay.Text( self:GetPos(), "I broke it down! #"..self.Door:EntIndex().."", 1.5,false )
					debugoverlay.Box( self.Door:GetPos(), self.Door:OBBMins(), self.Door:OBBMaxs(), 1.5, Color( 0, 255, 0, 128) )
					self:EmitSound("Wood.Break")
					self.Ready = true
					local p = ents.Create("prop_physics")
					p:SetModel(self.Door:GetModel())
					p:SetBodygroup(1, 1)
					p:SetSkin(self.Door:GetSkin())
					p:SetPos(self.Door:GetPos())
					p:SetAngles(self.Door:GetAngles())
					p:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					OpenLinkedAreaPortal(self.Door)
					self.Door:Remove()
					p:Spawn()
					
					local vel = self:EyePos():Angle()
					vel.p = vel.p
					vel = vel:Forward() * -1100 

					
					local phys = p:GetPhysicsObject()
					if phys then
						p:GetPhysicsObject():AddVelocity(vel)
						p:SetPhysicsAttacker(self)
					end
				else
					self.Door:TakeDamage(999999999,self,self)
					timer.Simple(0.1, function()
					
						self.Door:Remove()

					end)
				end
				self:SetCollisionGroup(COLLISION_GROUP_NPC)
			end

		end
		if (IsValid(self:GetEnemy())) then
			if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange + 30 and self:GetEnemy():Health() > 0) then
				if (engine.ActiveGamemode() == "teamfortress") then
					if (self.Grenade != nil and !self.Grenade:IsTFPlayer() and self:GetEnemy():EntIndex() == self.Grenade:EntIndex()) then return end
					self.loco:ClearStuck() 
					self:EmitSound(
						table.Random(
							{
								"npc/infected/hit/hit_punch_01.wav",
								"npc/infected/hit/hit_punch_02.wav",
								"npc/infected/hit/hit_punch_03.wav",
								"npc/infected/hit/hit_punch_04.wav",
								"npc/infected/hit/hit_punch_05.wav",
								"npc/infected/hit/hit_punch_06.wav",
								"npc/infected/hit/hit_punch_07.wav",
								"npc/infected/hit/hit_punch_08.wav",
								"npc/infected/hit/punch_boxing_bodyhit03.wav",
								"npc/infected/hit/punch_boxing_bodyhit04.wav",
								"npc/infected/hit/punch_boxing_facehit4.wav",
								"npc/infected/hit/punch_boxing_facehit5.wav",
								"npc/infected/hit/punch_boxing_facehit6.wav",
							}
						),
						85, 100
					)
					local dmginfo = DamageInfo()
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamageType(DMG_CLUB)
					dmginfo:SetDamage(math.random(1,4))
					if (GetConVar("skill"):GetInt() > 1) then
						dmginfo:ScaleDamage(1 + (GetConVar("skill"):GetInt() * 0.65))
					end
					self:GetEnemy():TakeDamageInfo(dmginfo) 
					if (self:GetEnemy():GetClass() == "infected") then
						if (math.random(1,20) == 1) then
							self:GetEnemy():OnKilled(dmginfo)
						end
					end
				else
					if (self.Grenade != nil and !self.Grenade:IsPlayer() and !self.Grenade:IsNPC() and self:GetEnemy():EntIndex() == self.Grenade:EntIndex()) then return end
					self.loco:ClearStuck() 
					self:EmitSound(
						table.Random(
							{
								"npc/infected/hit/hit_punch_01.wav",
								"npc/infected/hit/hit_punch_02.wav",
								"npc/infected/hit/hit_punch_03.wav",
								"npc/infected/hit/hit_punch_04.wav",
								"npc/infected/hit/hit_punch_05.wav",
								"npc/infected/hit/hit_punch_06.wav",
								"npc/infected/hit/hit_punch_07.wav",
								"npc/infected/hit/hit_punch_08.wav",
								"npc/infected/hit/punch_boxing_bodyhit03.wav",
								"npc/infected/hit/punch_boxing_bodyhit04.wav",
								"npc/infected/hit/punch_boxing_facehit4.wav",
								"npc/infected/hit/punch_boxing_facehit5.wav",
								"npc/infected/hit/punch_boxing_facehit6.wav",
							}
						),
						85, 100
					)
					local dmginfo = DamageInfo()
					dmginfo:SetAttacker(self)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamageType(DMG_CRUSH)
					dmginfo:SetDamage(math.random(1,4))
					if (GetConVar("skill"):GetInt() > 1) then
						dmginfo:ScaleDamage(1 + (GetConVar("skill"):GetInt() * 0.65))
					end
					self:GetEnemy():TakeDamageInfo(dmginfo) 
					if (self:GetEnemy():IsPlayer()) then
						self:GetEnemy():SetViewPunchAngles(self:GetEnemy():GetViewPunchAngles() + (Angle(math.random(-16,16),math.random(-16,16),math.random(-16,16))))
						self:GetEnemy():SendLua("LocalPlayer():EmitSound('Player.HitInternal')")
					end
					if (self:GetEnemy():GetClass() == "infected" and self:GetEnemy():Health() > 0 and !self.PlayingSequence2 and !self.PlayingSequence3) then
						if (math.random(1,30) == 1) then
							self:GetEnemy():OnKilled(dmginfo)
						else
							local v = self:GetEnemy()
							v:EmitSound("Weapon.HitInfected")
							local selanim = table.Random({"Shoved_Backward_01","Shoved_Backward_02"})
							local anim = v:LookupSequence(selanim)
							v:PlaySequenceAndMove(anim)
							v:EmitSound("L4D_Zombie.Shoved")
							timer.Stop("ShovedFinish"..v:EntIndex())
							timer.Create("ShovedFinish"..v:EntIndex(), v:SequenceDuration(anim) - 0.2, 1,function()
								if (v:IsOnGround() and v.Ready) then
									if (v:GetEnemy() != nil) then
										if (string.find(v:GetModel(),"mud")) then
					
											v:ResetSequence( v:SelectWeightedSequence(v:GetSequenceActivity(v:LookupSequence("mudguy_run"))  ) )			-- Set the animation
					
										else
											v:ResetSequence( v:SelectWeightedSequence(v:GetSequenceActivity(v:LookupSequence("run_01"))  ) )			-- Set the animation
										end
									else
										--v:SetCycle(0)
										v:ResetSequence( v:SelectWeightedSequence(v:GetSequenceActivity(v:LookupSequence("idle_neutral_01"))  ) )
										v:PlayActivityAndMove( v:GetSequenceActivity(v:LookupSequence("idle_neutral_01"))  ) 
									end
								end
							end)
							
							self:EmitSound("Weapon.HitInfected")
							local selanim = table.Random({"Shoved_Backward_01","Shoved_Backward_02"})
							local anim = self:LookupSequence(selanim)
							self:PlaySequenceAndMove(anim)
							self:EmitSound("L4D_Zombie.Shoved")
							timer.Stop("ShovedFinish"..self:EntIndex())
							timer.Create("ShovedFinish"..self:EntIndex(), self:SequenceDuration(anim) - 0.2, 1,function()
								if (self:IsOnGround() and v.Ready) then
									if (self:GetEnemy() != nil) then
										if (string.find(self:GetModel(),"mud")) then
					
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
					
										else
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
										end
									else
										--self:SetCycle(0)
										self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) )
										self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) 
									end
								end
							end)
						end
					end
				end
			else 
				self:EmitSound("L4D_Zombie.AttackMiss")
			end
		else
			self:EmitSound("L4D_Zombie.AttackMiss")
		end
	end
end

function ENT:IsNPC() 
	return true
end

local vec = Vector()
local traceres = {}
local tracedata = {
	endpos = vec,
	mask = bit.band(MASK_SOLID_BRUSHONLY, bit.bnot(CONTENTS_GRATE)),
	collisiongroup = COLLISION_GROUP_NONE,
	ignoreworld = false,
	output = traceres,
}

hook.Add("EntityTakeDamage","L4D2BloodSplatterDamageNew",function(ent,dmginfo)
	if (!dmginfo:IsDamageType(DMG_BURN) and !dmginfo:IsDamageType(DMG_BLAST) and !dmginfo:IsDamageType(DMG_DIRECT) and (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot())) then
		sound.Play( "player/survivor/splat/zombie_blood_spray_0"..math.random(1,6)..".wav", dmginfo:GetDamagePosition(), 55, math.random(95,105),0.3)
		for i=1,5 do
			timer.Simple(math.Rand(0.1,0.4), function() 
				sound.Play( "player/survivor/splat/zombie_blood_spray_0"..math.random(1,6)..".wav", dmginfo:GetDamagePosition(), 55, math.random(95,105),0.3)
			end)
		end
	end

end)

hook.Add("ScaleNPCDamage","InfectedDamage",function(npc,hitgroup,dmginfo)
	
	if (string.find(npc:GetModel(),"_riot")) then
		if hitgroup != 20 then
			dmginfo:ScaleDamage(0.25)
			npc:EmitSound("SolidMetal.BulletImpact")
		end
	end
	if (npc:GetClass() == "infected" and !string.find(npc:GetModel(),"ceda") and !string.find(npc:GetModel(),"_riot")) then	
		if (hitgroup == HITGROUP_HEAD) then
			npc.WasShotInTheHead = true
			dmginfo:ScaleDamage(4)
		elseif (hitgroup == HITGROUP_RIGHTARM and !npc.IsRightArmCutOff) then
					
			local headgib = ents.Create("prop_ragdoll")
			headgib:SetModel("models/infected/limbs/limb_male_rarm01.mdl")
			headgib:SetPos(npc:GetAttachment(2).Pos)
			headgib:Spawn()
			headgib:Activate()
			headgib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			if (IsValid(headgib:GetPhysicsObject())) then
				headgib:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.05)
			end
			timer.Simple(math.random(1,10),function()
				if (IsValid(headgib)) then
					headgib:Fire("FadeAndRemove","",0.01)
				end
			end)
			local eyes = 2
			ParticleEffectAttach("blood_decap", PATTACH_POINT_FOLLOW, npc, eyes)
			ParticleEffectAttach("blood_decap_arterial_spray", PATTACH_POINT_FOLLOW, npc, eyes)
			ParticleEffectAttach("blood_decap_fountain", PATTACH_POINT_FOLLOW, npc, eyes)
			ParticleEffectAttach("blood_decap_streaks", PATTACH_POINT_FOLLOW, npc, eyes)
			npc:ManipulateBoneScale(npc:LookupBone("ValveBiped.Bip01_R_Forearm"),Vector(0,0,0))
			npc:ManipulateBoneScale(npc:LookupBone("ValveBiped.Bip01_R_Hand"),Vector(0,0,0))
			npc.IsRightArmCutOff = true
			npc:EmitSound("Blood.Spurt")
		elseif (hitgroup == HITGROUP_LEFTARM and !npc.IsLeftArmCutOff) then
			
			local headgib = ents.Create("prop_ragdoll")
			headgib:SetModel("models/infected/limbs/limb_male_larm01.mdl")
			headgib:SetPos(npc:GetAttachment(3).Pos)
			headgib:Spawn()
			headgib:Activate()
			headgib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			if (IsValid(headgib:GetPhysicsObject())) then
				headgib:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.05)
			end
			timer.Simple(math.random(1,10),function()
				if (IsValid(headgib)) then
					headgib:Fire("FadeAndRemove","",0.01)
				end
			end)
			local eyes = 4
			ParticleEffectAttach("blood_decap", PATTACH_POINT_FOLLOW, npc, eyes)
			ParticleEffectAttach("blood_decap_arterial_spray", PATTACH_POINT_FOLLOW, npc, eyes)
			ParticleEffectAttach("blood_decap_fountain", PATTACH_POINT_FOLLOW, npc, eyes)
			ParticleEffectAttach("blood_decap_streaks", PATTACH_POINT_FOLLOW, npc, eyes)
			npc:ManipulateBoneScale(npc:LookupBone("ValveBiped.Bip01_L_Forearm"),Vector(0,0,0))
			npc:ManipulateBoneScale(npc:LookupBone("ValveBiped.Bip01_L_Hand"),Vector(0,0,0)) 
			npc.IsLeftArmCutOff = true
			npc:EmitSound("Blood.Spurt")
		end
	end
end)
----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	-- This function is called when the entity is first spawned. It acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		if (self:Health() < 0) then
			coroutine.yield()
			return
		end 
		if (IsValid(self:GetEnemy()) and (self:GetEnemy():IsFlagSet(FL_NOTARGET))) then 
			self.Grenade = nil
			self.Enemy = nil
		end
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if self.Ready and !self.ContinueRunning then 
			
			if ( !self.ContinueRunning and !self:IsOnFire() and self:HaveEnemy() and !GetConVar("ai_disabled"):GetBool() ) then
				-- Now that we have an enemy, the code in this block will run
				if (self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))) then
					self.PlayingSequence2 = false	
					self.PlayingSequence3 = false	
				end
				self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self.loco:SetDesiredSpeed( 280 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self.loco:SetAcceleration(150)
				if (!self.PlayingSequence2 and !self.PlayingSequence3) then
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )
				end
				self:ChaseEnemy()
			else
				-- Since we can't find an enemy, lets wander
				-- Its the same code used in Garry's test bot
				if (self:IsOnGround()) then
					if (math.random(1,800) == 1) then
						local act = self:GetSequenceActivity(self:LookupSequence("shamble_01"))
						--self.loco:SetDesiredSpeed( self:GetSequenceGroundSpeed( seq ) )
						self:PlayActivityAndMove( act )
						--self.loco:SetDesiredSpeed( self:GetSequenceGroundSpeed( seq ) )
						--self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400, 1 ) -- Walk to a random 
						self.Walking = true 
					else
						self.Walking = false
					end
				end
			end
			coroutine.wait(0.01)
		
		elseif (!self.Ready or self.ContinueRunning or self.PlayingSequence2) then

			if (self:IsOnFire() and !self.OnFire and !string.find(self:GetModel(),"ceda")) then

				-- Since we can't find an enemy, lets wander
				-- Its the same code used in Garry's test bot
				local anim = self:SelectRandomSequence(self:GetSequenceActivity(self:LookupSequence("run_onfire")))
				self:PlaySequenceAndMove( anim )
				self:EmitSound("L4D_Zombie.IgniteScream")
				timer.Create("FireFireFire!"..self:EntIndex(), self:SequenceDuration(anim) - 0.5, 0, function()
					if (IsValid(self) and self:Health() > 0) then
						self:PlaySequenceAndMove( anim )
					else
						return
					end
				end)
				self.OnFire = true
			elseif (self.ContinueRunning) then
				-- Now that we have an enemy, the code in this block will run
				--self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self.loco:Approach( self:GetEnemy():GetPos(),1 ) -- Walk to a random place within about 400 units (yielding)
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			end
			self.loco:SetDesiredSpeed( self:GetSequenceGroundSpeed( self:GetSequence() ) )
			timer.Stop("AngryExpression"..self:EntIndex())
			coroutine.wait(0.01)
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		coroutine.wait(0.01)
		coroutine.yield()
	end

end	

hook.Add( "ShouldCollide", "SkeletonCollision", function( ent1, ent2 )

    -- If players are about to collide with each other, then they won't collide.
    if ( ent1:GetClass() == "npc_tf_zombie" and ent2:GetClass() == "npc_tf_zombie" ) then return false end

end )

function ENT:BodyUpdate()

	local act = self:GetActivity()

	--
	-- This helper function does a lot of useful stuff for us.
	-- It sets the bot's move_x move_y pose parameters, sets their animation speed relative to the ground speed, and calls FrameAdvance.
	-- 
	if (!self:IsOnFire() and self:IsOnGround() and (IsValid(self:GetEnemy()) and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0) then
		if (self.Ready and !self.PlayingSequence2 and !self.PlayingSequence3) then
			self:BodyMoveXY()
			--[[
			local movement = self:GetMovement(true)
			self:SetPoseParameter("move_x", movement.x)
			self:SetPoseParameter("move_y", movement.y)
			local forward = self:GetForward()
			local velocity = self:GetVelocity()
			forward.z = 0
			velocity.z = 0
			local forwardAng = forward:Angle()
			local velocityAng = velocity:Angle()
			self:SetPoseParameter("move_yaw", math.AngleDifference(velocityAng.y, forwardAng.y))]]
			-- BodyMoveXY() already calls FrameAdvance, calling it twice will affect animation playback, specifically on layers
			return

		end
	end

	--
	-- If we're not walking or running we probably just want to update the anim system
	--
	self:FrameAdvance()

end

function ENT:Think()
	if SERVER then
	
		if (table.Count(getAllInfected()) > 30) then
			self:Remove()
		end
		
		if (IsValid(self:GetEnemy())) then
					if (isbeingMobbed(self:GetEnemy())) then
						if (!self:GetEnemy().IsMobbed) then
							self.MobbedMusic = CreateSound(self:GetEnemy(),"Event.Mobbed")
							--self.MobbedMusic:Play()
							self:GetEnemy().IsMobbed = true
						end
					else
						if (self:GetEnemy().IsMobbed) then
							if (self.MobbedMusic != nil) then
								--self.MobbedMusic:FadeOut(2)
							end
							self:GetEnemy().IsMobbed = false
						end
					end
		end
	end
					if (SERVER and !self:IsInWorld()) then
						if (math.random(1,20) == 1) then
							local dmginfo = DamageInfo()
							self:OnKilled(dmginfo)
						end
					end
					
					if (math.random(1,100) == 1 and IsValid(self:GetEnemy()) and string.find(self:GetModel(),"clown")) then
							
						local thevictim = ents.Create("infected")
						thevictim:SetAngles(Angle(0,math.random(0,360),0))
						thevictim:SetOwner(self)
						thevictim:Spawn()
						thevictim:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						local pos = thevictim:FindSpot("random", {pos=self:GetEnemy():GetPos(),radius = 8000,type="hiding",stepup,stepup=800,stepdown=800})
						if (pos != nil) then
							thevictim:SetPos(pos)
						end
						thevictim:SetEnemy(self:GetEnemy())
						print("Spawning incoming infected")
					end
	if (self.PlayingSequence2) then

		local cycle = self:GetCycle()
		if self.lastCycle > cycle then return end 
		if self.lastCycle == cycle and cycle == 1 then return end
		self.lastCycle = cycle
		if isfunction(self.callback) then
			self.PlayingSequence = true
			local res = self.callback(self, cycle)
			self.PlayingSequence = false
		end

	end
	if (IsValid(self:GetEnemy()) and (self:GetEnemy():IsFlagSet(FL_NOTARGET))) then 
		self.Grenade = nil
		self.Enemy = nil
	end
	if SERVER then 
		if (self.Ready and math.random(1,150) == 1) then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(),60)) do
				if (v:GetClass() == "infected" and self.Enemy == nil and v:EntIndex() != self:EntIndex() and (math.random(1,100) == 1)) then
					self.PlayingSequence2 = false
					self.PlayingSequence3 = false
					self:SetEnemy(v)
				end
			end
		end
		if (IsValid(self:GetEnemy())) then
			local bound1, bound2 = self:GetCollisionBounds()
			self:DirectPoseParametersAt((self:GetEnemy():GetBonePosition(1) - self:GetAngles():Forward())--[[ + Vector(0,0,math.max(bound1.z, bound2.z) - 30)]], "body", self:EyePos())
			if (self:GetEnemy():Health() < 0 or self:GetEnemy():IsFlagSet(FL_NOTARGET) or (self:GetEnemy():IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool())) then
				self.Enemy = nil
			end
		end
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),120)) do
			if (v:GetClass() == "entityflame" || v:GetClass() == "env_fire" and !v.IsSpitterFire) then
				self:Ignite(60,120)
			end
		end
		if (self.Idling and self:GetCycle() == 0.9) then
			self:SetCycle(0)
			self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) 
		end
		if (!self:IsOnGround()) then
			if (!self.HaventLandedYet) then
				self:SetCycle(0)
				self:ResetSequence("fall_0"..math.random(1,9))
				self.HaventLandedYet = true
			end
		else
			if (self.HaventLandedYet) then
				local anim = self:LookupSequence("landing01")
				if (math.random(1,3) == 1) then
					if (IsValid(self:GetEnemy())) then
						anim = self:LookupSequence("landing_hard0"..math.random(1,6))
					else
						anim = self:LookupSequence("landing_hard01")
					end
				else
					if (IsValid(self:GetEnemy())) then
						anim = self:LookupSequence("landing0"..math.random(2,4))
					end
				end
				self.PlayingSequence2 = false
				self.PlayingSequence3 = false
				self:PlaySequenceAndMove(anim)
				timer.Simple(self:SequenceDuration(anim) - 0.5,function()
					self.PlayingSequence2 = false
					self.PlayingSequence3 = false
					self.loco:SetAcceleration(1000)
					if (self:IsOnGround()) then
						if (self:GetEnemy() != nil) then
							if (string.find(self:GetModel(),"mud")) then
	
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
	
							else
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
								self:StartActivity(self:GetSequenceActivity(self:LookupSequence("run_01")))
							end
						else
							self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Running_to_Standing"))  ) )
							self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Running_to_Standing"))  )
						end
					end
				end)
				self.HaventLandedYet = false
			end
		end
		if (self.Ready and self:GetCycle() == 0 and self:GetActivity() == -1 and !(self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_01")) && self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("mudguy_run")))) then
			self:PlayActivityAndMove( self:GetActivity() )
		elseif (self.Ready and !self.Idling and self:GetEnemy() == nil and (self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("mudguy_run")))) then 

			local mad = self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))
			if (self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_01"))) then
				mad = self:GetSequenceActivity(self:LookupSequence("Running_to_Standing"))
			end
			local mad2 = self:SelectRandomSequence(mad) 
			--self:StartActivity( mad )
			self:PlaySequenceAndMove( mad2 )
			self.Idling = true
		end
		if (!GetConVar("ai_disabled"):GetBool() and self.Ready) then
						if (table.Count(getAllInfected()) >= 30) then -- now thats 30
							self:Remove()
						end
			if (engine.ActiveGamemode() == "teamfortress") then
				if (GAMEMODE:EntityTeam(self.Enemy) == TEAM_GREEN and !(self.Enemy:HasPlayerState(PLAYERSTATE_JARATED) and self.Enemy:HasPlayerState(PLAYERSTATE_PUKEDON))) then 
					self.Enemy = nil
					self:FindEnemy() 
				end
			end
			self:SetNWInt( 'NetworkedActivity', self:GetActivity() )
			self.loco:SetGravity( 700 )
			self.loco:SetJumpGapsAllowed( true )
			self.loco:SetAvoidAllowed( true )
			self.loco:SetJumpHeight( 200 )
			for k, v in pairs(nearestDoor(self)) do
				if (IsValid(v)) then
					-- open a door if we see one blocking our path
					local targetpos = v:GetPos() + Vector(0, 0, 45)
					if util.TraceLine({start = self:EyePos(), endpos = targetpos, filter = function( ent ) return ent == v end}).Entity == v then
						self.Door = v
					end
				end
			end 
			for k,v in ipairs(nearestPipebomb(self)) do
				if (IsValid(v)) then
					self.Grenade = v
				end
			end
			if (!IsValid(self.Grenade)) then
				self.Grenade = nil
			end
			if (IsValid(self.AvoidingEntity) and self.AvoidingEntity:GetPos():Distance(self:GetPos()) > 120 ) then
				self.AvoidingEntity = nil
				self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			end
		end
		if (self:WaterLevel() > 2) then
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(self)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamageType(DMG_DROWN)
			dmginfo:SetDamage(self:Health())
			self:TakeDamageInfo(dmginfo) 
		end
	end 
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 0) then
		self.Enemy = nil
		self:FindEnemy()
	end
	if SERVER then
		if (!GetConVar("ai_disabled"):GetBool()) then
			--if (self:IsOnFire() and !string.find(self:GetModel(),"ceda")) then
				--self:PlaySequenceAndMove( self:LookupSequence("run_onfire") )
			--end
			if (IsValid(self.Door) and self:IsOnGround() and self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
				self.loco:SetDesiredSpeed( 0 )
				self.loco:SetAcceleration(0)
			end
			if (!IsValid(self.Door) and self.WasAttackingDoor) then

				self.Ready = true
				self:SetCollisionGroup(COLLISION_GROUP_NPC)
				self.WasAttackingDoor = false

			end
			if (self.PlayingSequence2) then
				self:SetPlaybackRate(1)
			end
			if (IsValid(self.Door) and !self.ContinueRunning and self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
				local targetheadpos,targetheadang = self.Door:GetBonePosition(1) -- Get the position/angle of the head.
				if (!self.MeleeAttackDelay2 or CurTime() > self.MeleeAttackDelay2) then
					if (self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
						self.OldEnemy = self.Enemy
						self.Ready = false
						self.WasAttackingDoor = true
						self:SetEnemy(nil)
						local anim = self:LookupSequence("AttackDoor_01")
						self.MeleeAttackDelay = CurTime() + 0.2
						self.MeleeAttackDelay2 = CurTime() + self:SequenceDuration(anim) - 0.2
						self.loco:ClearStuck() 
						self:SetPlaybackRate(1)
						--self:SetCycle(0)
						if (self:IsOnGround()) then
							self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(anim) ) )			-- Set the animation
						end
					end
				end
			end
			if (IsValid(self:GetEnemy()) and self:IsOnGround() and !self.PlayingSequence3 and !self.PlayingSequence2) then
				if (!self.PlayingSequence2 and !self.ContinueRunning and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 and self:GetEnemy():Health() > 0) then
					local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
					if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay || CurTime() > self.MeleeAttackDelay)) then
						if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange) then
							if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then
								--self:SetCollisionGroup(COLLISION_GROUP_NPC)
							end
							if (!string.find(self:GetModel(),"mud")) then
								local anim
								if (self:GetEnemy():GetModelScale() > 0.5) then
									if (self:GetEnemy():IsNPC() and self:GetEnemy():Classify() == CLASS_HEADCRAB || self:GetEnemy():GetNWBool( "IsIncapped", false ) == true || self:GetEnemy().Incap) then
										anim = self:LookupSequence("AttackIncap_01") 
									else
										if (string.find(self:GetModel(),"female") and !string.find(self:GetModel(),"formal") and !string.find(self:GetModel(),"_tshirt_skirt") and !string.find(self:GetModel(),"_tanktop_jeans")) then
											anim = self:LookupSequence("female_melee_noel02")
										else
											anim = self:LookupSequence("Melee_01") 
										end
									end
								elseif (self:GetEnemy():GetModelScale() < 0.5 or self:GetEnemy():Classify() == CLASS_HEADCRAB) then
									anim = self:LookupSequence("AttackIncap_01") 
								end
								self:StartActivity(self:GetSequenceActivity(anim)) 
								self.MeleeAttackDelay = CurTime() + self:SequenceDuration(anim) - 0.2
								self.loco:ClearStuck() 
							else
								local selanim = self:LookupSequence("Melee_Moving0"..math.random(1,3))
								local anim = self:GetSequenceActivity(selanim)
								self.MeleeAttackDelay = CurTime() + self:SequenceDuration(selanim) 
								self:AddGesture(anim)
								self.loco:ClearStuck() 
							end
							self.DontWannaUseSameSequence = false
						end
					end
				end
				if (!self.ContinueRunning and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange and self:GetEnemy():Health() > 0 and !self.PlayingSequence3) then   
					local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angl e of the head.
					if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay || CurTime() > self.MeleeAttackDelay)) then
						if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then 
							local selanim = self:LookupSequence("Melee_Moving0"..math.random(1,3))
							local anim = self:GetSequenceActivity(selanim)
							self.MeleeAttackDelay = CurTime() + self:SequenceDuration(selanim)
							self:AddGesture(anim,true)
							self.loco:ClearStuck() 
							if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange) then 
								if (!self.PlayingSequence3 and self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02"))) then
									if (IsValid(self:GetEnemy())) then
										if (self.loco:IsUsingLadder()) then
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  ) )			-- Set the animation
										else
											if (self:IsOnGround() and self.Ready) then
												if (string.find(self:GetModel(),"mud")) then
							
													self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
							
												else
													self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
												end
											end
										end
									else
										if (self:IsOnGround() and self.Ready) then
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("shamble_01")) ) ) 
										end
									end
								end
							end
						end
					end
				end
				if (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0 or self.PlayingSequence and !self.ContinueRunning) then
					self.loco:SetDesiredSpeed( 0 )
					self.loco:SetAcceleration(0)
				elseif (!self.ContinueRunning and !self:IsOnFire() and self:IsOnGround() and (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0 and !self.PlayingSequence3) then
					if (!self.PlayingSequence3 and self.Ready and self.MeleeAttackDelay and CurTime() < self.MeleeAttackDelay) then
						if (CurTime() < self.MeleeAttackDelay) then
							self.MeleeAttackDelay = CurTime() + 0.01
						end
						
						if (!self.PlayingSequence2 and !self.PlayingSequence3 and !self.DontWannaUseSameSequence) then
							if (IsValid(self:GetEnemy())) then
								if (self.loco:IsUsingLadder()) then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  ) )		-- Set the animation
								else
									if (self:IsOnGround()) then
										if (string.find(self:GetModel(),"mud")) then
					
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  )	 )		-- Set the animation
					
										else
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
										end
									end
								end
							else
								if (self:IsOnGround()) then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("shamble_01")) ) )
								end
							end
							self.DontWannaUseSameSequence = true
						end
					elseif (self.Ready) then
						if (GetConVar("skill"):GetInt() > 1) then
							self.loco:SetDesiredSpeed( 250  )
							self.loco:SetAcceleration(150 )
						else
							self.loco:SetDesiredSpeed(250 * self:GetModelScale())
							self.loco:SetAcceleration(150 * self:GetModelScale())
						end
					end
				end
			elseif (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 0) then
				self:SetEnemy(nil)
			end
		end
		if (self.ContinueRunning or self:IsOnFire() or self.PlayingSequence2) then
			self.PlayingSequence = false
		end
	end
	self:SetPlaybackRate(1)
	self:NextThink(CurTime())
	return true
end

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is one.
----------------------------------------------------
function ENT:ChaseEnemy( options )

	if (!IsValid(self:GetEnemy())) then return end
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 300 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position
	
	if ( !path:IsValid() ) then return "failed" end
	
	if (math.random(1,30) == 1 and self:Health() > 0 and !self.HaventLandedYet and !self.EncounteredEnemy and !self:IsOnFire() and !self.PlayingSequence and !self.PlayingSequence2) then 
			local thetables = {
				"violent_alert01_Common_"..table.Random({"a","b","c","d","e"}),
				"Idle_Acquire_05",
				"Idle_Acquire_06",
				"Idle_Acquire_11",
			}
			local mad = table.Random(thetables)
			self:PlaySequenceAndMove( mad ) 
			self:EmitSound(table.Random({"L4D_Zombie.Alert"}))
			
			timer.Stop("Sequuence"..self:EntIndex())
			timer.Create("Sequuence"..self:EntIndex(), self:SequenceDuration(mad), 1, function()
				if (!self:IsOnFire()) then
					if (string.find(self:GetModel(),"mud")) then
	
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
	
					else
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
					end
				end
			end)
	
			self.EncounteredEnemy = true
	end
	while ( path:IsValid() and IsValid(self:GetEnemy()) and !self.ContinueRunning and !self:IsOnFire() and !self.PlayingSequence and !self.PlayingSequence3 and !self.PlayingSequence2 ) do
		if (!self.PlayingSequence3 and self:GetCycle() == 1 and self:GetSequence() != self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))) and !(self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("mudguy_run")))) then  
			if (self.loco:IsUsingLadder()) then
				self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  ) )			-- Set the animation
			else
				if (self:IsOnGround()) then
					if (string.find(self:GetModel(),"mud")) then

						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
						self:StartActivity(self:GetSequenceActivity(self:LookupSequence("mudguy_run")))

					else
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
						self:StartActivity(self:GetSequenceActivity(self:LookupSequence("run_01")))
					end
				end
			end
		end
		local pos = self:GetEnemy():GetPos()
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(),180)) do -- avoid other infected
				if (v:GetClass() == "infected" and v:EntIndex() != self:EntIndex()) then
					--pos = self:GetEnemy():GetPos() + (self:GetForward() + v:GetForward()*(-130)) + (v:GetRight() * -130 - self:GetRight()*(130))
					self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				end
			end
		end
		if (IsValid(self:GetEnemy()) and (self:GetEnemy():IsFlagSet(FL_NOTARGET))) then 
			self.Enemy = nil
		end
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),120)) do
			if (v ~= self and IsValid(v) and (v.IsInfected or v:GetClass() == "infected")) then
				self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			else
				self:SetCollisionGroup(COLLISION_GROUP_NPC)
			end
		end
		if (self.PlayingSequence2 or self.PlayingSequence3) then return false end
		if ( path:GetAge() > 0.02 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute(self, pos)-- Compute the path towards the enemy's position again
			path:Update( self )								-- This function moves the bot along the path
		end
		if (self:GetEnemy():IsPlayer()) then
			if (math.random(1,80) == 1) then
				debugoverlay.Text( self:GetPos(), "I can see you, "..self:GetEnemy():GetName(), 3,false )
			end
		end
		debugoverlay.Line(path:GetStart(), path:GetEnd(), 0.2, Color(0,255,0), false)
		if ( options.draw ) then path:Draw() end
		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end
function ENT:OnInjured( dmginfo )
	if (string.find(self:GetModel(),"ceda")) then
		if SERVER then
			self:Extinguish()
			self:StopSound("General.BurningFlesh")
			if (dmginfo:GetAttacker():GetClass() == "entityflame" or dmginfo:GetAttacker():GetClass() == "tf_entityflame") then
				self:StopSound("General.BurningObject")
				dmginfo:SetDamage(0)
				dmginfo:GetAttacker():Fire("kill","",0.01)
			end
		end 
		if (dmginfo:IsDamageType(DMG_BURN)) then
			dmginfo:SetDamage(0)
		end
		self.Ready = true
		if (!self.deflated) then
			self:EmitSound("CEDA.suit.deflate")	
			self.deflated = true
		end
	end
	if (dmginfo:IsDamageType(DMG_BULLET) and self:Health() > 0 and math.random(1,4) == 1) then
		self:EmitSound("L4D_Zombie.Shot")
	elseif (dmginfo:IsDamageType(DMG_CLUB) and self:Health() > 0 and math.random(1,4) == 1) then
		self:EmitSound("L4D_Zombie.Shot")
	end
	if (((math.random(1,8) == 1 && dmginfo:IsDamageType(DMG_BULLET) || dmginfo:IsDamageType(DMG_CLUB)) and !dmginfo:IsDamageType(DMG_DROWN)) and self:Health() >= 0) then
		self:EmitSound("Weapon.HitInfected")
		local selanim = table.Random({"Run_Stumble_01","Shoved_Backward_01","Shoved_Backward_02","Shoved_Backward_03","Shoved_Forward_01","Shoved_Leftward_01","Shoved_Rightward_01"})
		local anim = self:LookupSequence(selanim)
		self:PlaySequenceAndMove(anim)
		self:EmitSound("L4D_Zombie.Shoved")
		timer.Stop("ShovedFinish"..self:EntIndex())
		timer.Create("ShovedFinish"..self:EntIndex(), self:SequenceDuration(anim) - 0.2, 1,function()
			if (self:IsOnGround() and self.Ready) then
				if (self:GetEnemy() != nil) then
					if (string.find(self:GetModel(),"mud")) then

						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation

					else
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
					end
				else
					--self:SetCycle(0)
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) )
					self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) 
				end
			end
		end)
	end
	if (dmginfo:GetAttacker():GetClass() == "entityflame" or dmginfo:GetAttacker():GetClass() == "tf_entityflame") then
		dmginfo:GetAttacker():StopSound("General.BurningObject")
	end
	if (dmginfo:IsDamageType(DMG_ACID)) then
		dmginfo:ScaleDamage(0)
		dmginfo:SetDamageType(DMG_GENERIC)
	elseif (dmginfo:IsDamageType(DMG_BLAST)) then
		self:EmitSound("Weapon.HitInfected")
		local selanim = table.Random({"Run_Stumble_01","Shoved_Backward_01","Shoved_Backward_02","Shoved_Backward_03","Shoved_Forward_01","Shoved_Leftward_01","Shoved_Rightward_01"})
		local anim = self:LookupSequence(selanim)
		self:PlaySequenceAndMove(anim)
		self:EmitSound("L4D_Zombie.Shoved")
		
			timer.Stop("Sequuence"..self:EntIndex())
			timer.Create("Sequuence"..self:EntIndex(), self:SequenceDuration(anim), 1, function()
			if (self:IsOnGround() and self.Ready) then
				if (self:GetEnemy() != nil) then
					if (string.find(self:GetModel(),"mud")) then

						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation

					else
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_01"))  ) )			-- Set the animation
					end
				else
					--self:SetCycle(0)
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) )
					self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle_neutral_01"))  ) 
				end
			end
		end)
	elseif (dmginfo:IsDamageType(DMG_BURN) and !string.find(self:GetModel(),"ceda")) then
		self.Ready = false
		self:SetEnemy(nil)
		self:Ignite(30,120,dmginfo:GetAttacker())
		if (!self.Burning) then
			self:StopSound("General.BurningFlesh")
			self:EmitSound("General.BurningFlesh")
			self.Burning = true
		end
		if (math.random(1,20) == 1) then
			self:EmitSound("L4D_Zombie.IgniteScream")
		end
	end
	if (dmginfo:GetAttacker() != nil) then
		local ent = dmginfo:GetAttacker()
		if (ent:IsPlayer() and (ent:IsFlagSet(FL_NOTARGET) or GetConVar("ai_ignoreplayers"):GetBool())) then 
		else
			self:SetEnemy(dmginfo:GetAttacker())
		end
	end
	if (!self.flinchFinish) then
		self:RestartGesture(self:GetSequenceActivity(self:LookupSequence("flinch_02")),true)
		self.flinchFinish = true
		timer.Create("FlinchFinished"..self:EntIndex(), self:SequenceDuration(self:LookupSequence("flinch_02")), 1, function()
			self.flinchFinish = false
		end)
	end
	if (dmginfo:IsDamageType(DMG_BULLET) and self:Health() > 0) then
		if (math.random(1,6) == 1) then
			self:EmitSound("L4D_Zombie.BulletImpact")
		end
	end
	if (dmginfo:IsDamageType(DMG_CLUB)) then
		dmginfo:ScaleDamage(0.4) 
	end
	if (!string.find(self:GetModel(),"riot")) then
		if (GetConVar("skill"):GetInt() > 1) then
			if (!dmginfo:IsDamageType(DMG_BUCKSHOT)) then
				dmginfo:ScaleDamage(1.5 / (GetConVar("skill"):GetInt() * 0.5))
			else
				dmginfo:ScaleDamage(1.0) 
			end
		else

			if (!dmginfo:IsDamageType(DMG_BURN)) then
				dmginfo:ScaleDamage(1.5)
			else
				dmginfo:ScaleDamage(0.8)
			end
		end
		if (dmginfo:GetInflictor():GetMoveType() == MOVETYPE_VPHYSICS) then
			dmginfo:ScaleDamage(3)
		end
	end
end
function ENT:Touch( entity )
end
local deathanimfemaletbl = 
{

	"death_01",
	"death_02a",
	"death_02c",
	"death_03",
	"death_05",
	"death_06",
	"Death_m02a",
	"Death_m05",
	"Death_m09",
	"Death_m11_01a",
	"Death_m11_01b",
	"Death_m11_02a",
	"Death_m11_02b",
	"Death_m11_02c",
	"Death_m11_02d",
	"Death_m11_03a",
	"Death_m11_03b",
	"Death_m11_03c",

}
local deathbyshotgunanimtbl = 
{

	"Death_shotgun_Forward",
	--"Death_Shotgun_Leftward",
	--"Death_Shotgun_Rightward",
	--"Death_Shotgun_Rightward01",
	--"Death_Shotgun_Rightward02",
	"Death_Shotgun_Backward_03",
	"Death_Shotgun_Backward_04",
	"Death_Shotgun_Backward_05",
	"Death_Shotgun_Backward_06",
	"Death_Shotgun_Backward_07",
	"Death_Shotgun_Backward_08",
	"Death_Shotgun_Backward_09",
	--"Death_Shotgun_Backward_collapse"

}
local deathanimtbl = 
{

	"death_01",
	"death_02a",
	"death_02c",
	"death_03",
	"death_05",
	"death_06", 
	"death_07",
	"death_08",
	"death_08b",
	"death_08",
	"death_10ab",
	"death_10b",
	"death_10c",
	"death_11_01a",
	"death_11_01b",
	"death_11_02a",
	"death_11_02b",
	"death_11_02c",
	"death_11_02d",
	"death_11_03a",
	"death_11_03b",
	"death_11_03c"

}

local deathanimfemaletblrun = 
{

	"DeathRunning_01",
	"DeathRunning_02",
	"DeathRunning_04",
	"DeathRunning_05",
	"DeathRunning_06",
	"DeathRunning_07",
	"DeathRunning_09",
	"DeathRunning_10",
	"DeathRunning_m04",
	"DeathRunning_m09",
	"DeathRunning_m10",
	"DeathRunning_m11a",
	"DeathRunning_m11b",
	"DeathRunning_m11c"
	
}
local deathanimtblrun = 
{

	"DeathRunning_01",
	"DeathRunning_03",
	"DeathRunning_04",
	"DeathRunning_05",
	"DeathRunning_06",
	"DeathRunning_07",
	"DeathRunning_08",
	"DeathRunning_09",
	"DeathRunning_10",
	"DeathRunning_11a",
	"DeathRunning_11b",
	"DeathRunning_11c",
	"DeathRunning_11d",
	"DeathRunning_11e",
	"DeathRunning_11f",
	"DeathRunning_11g"
	
}

function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local pos = self:GetPos()
	self:PrecacheGibs()
	if (self.WasShotInTheHead and !string.find(self:GetModel(),"ceda")) then
		self:EmitSound("L4D_Zombie.HeadlessCough")
		self:EmitSound("Blood.Spurt")
		local headgib = ents.Create("prop_ragdoll")
		headgib:SetModel("models/infected/limbs/limb_male_head01.mdl")
		headgib:SetPos(self:GetAttachment(1).Pos)
		headgib:SetAngles(self:GetAttachment(1).Ang)
		headgib:Spawn()
		headgib:Activate()
		headgib:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		if (IsValid(headgib:GetPhysicsObject())) then
			headgib:GetPhysicsObject():AddVelocity(dmginfo:GetDamageForce() * 0.05)
		end
		timer.Simple(math.random(1,10),function()
			if (IsValid(headgib)) then
				headgib:Fire("FadeAndRemove","",0.01)
			end
		end)
        local eyes = 1
        ParticleEffectAttach("blood_decap", PATTACH_POINT_FOLLOW, self, eyes)
        ParticleEffectAttach("blood_decap_arterial_spray", PATTACH_POINT_FOLLOW, self, eyes)
        ParticleEffectAttach("blood_decap_fountain", PATTACH_POINT_FOLLOW, self, eyes)
        ParticleEffectAttach("blood_decap_streaks", PATTACH_POINT_FOLLOW, self, eyes)
		self:ManipulateBoneScale(self:LookupBone("ValveBiped.Bip01_Head1"),Vector(0,0,0))
	else
		if (!dmginfo:IsDamageType(DMG_BURN)) then
			self:EmitSound(table.Random({ 
				"npc/infected/action/die/mp/odd_2.wav",
				"npc/infected/action/die/mp/odd_3.wav",
				"npc/infected/action/die/mp/odd_4.wav",
				"npc/infected/action/die/mp/odd_5.wav",
				"npc/infected/action/die/mp/squeal_1.wav",
				"npc/infected/action/die/mp/squeal_2.wav",
				"npc/infected/action/die/mp/squeal_3.wav",
				"npc/infected/action/die/mp/squeal_4.wav",
				"npc/infected/action/die/death_14.wav",
				"npc/infected/action/die/death_17.wav",
				"npc/infected/action/die/death_18.wav",
				"npc/infected/action/die/death_19.wav",
				"npc/infected/action/die/death_22.wav",
				"npc/infected/action/die/death_23.wav",
				"npc/infected/action/die/death_24.wav",
				"npc/infected/action/die/death_25.wav",
				"npc/infected/action/die/death_26.wav",
				"npc/infected/action/die/death_27.wav",
				"npc/infected/action/die/death_28.wav",
				"npc/infected/action/die/death_29.wav",
				"npc/infected/action/die/death_30.wav",
				"npc/infected/action/die/death_32.wav",
				"npc/infected/action/die/death_33.wav",
				"npc/infected/action/die/death_34.wav",
				"npc/infected/action/die/death_35.wav",
				"npc/infected/action/die/death_36.wav",
				"npc/infected/action/die/death_37.wav",
				"npc/infected/action/die/death_38.wav",
				"npc/infected/action/die/"..self.gender.."/death_40.wav",
				"npc/infected/action/die/"..self.gender.."/death_41.wav",
				"npc/infected/action/die/"..self.gender.."/death_42.wav",
				"npc/infected/action/die/"..self.gender.."/death_43.wav",
				"npc/infected/action/die/"..self.gender.."/death_44.wav",
				"npc/infected/action/die/"..self.gender.."/death_45.wav",
				"npc/infected/action/die/"..self.gender.."/death_46.wav",
				"npc/infected/action/die/"..self.gender.."/death_47.wav",
				"npc/infected/action/die/"..self.gender.."/death_48.wav",
				"npc/infected/action/die/"..self.gender.."/death_49.wav"
			}),75,math.random(95,105),1,CHAN_VOICE) 
		end
	end
	if SERVER then
		
		self.Ready = false
		local death = table.Random(deathanimtbl)
		local death2 = self:GetSequenceActivity(self:LookupSequence(death))
		if (string.find(self:GetModel(),"female") and !string.find(self:GetModel(),"formal") and !string.find(self:GetModel(),"_tshirt_skirt") and !string.find(self:GetModel(),"_tanktop_jeans")) then
			death = table.Random(deathanimfemaletbl)
			death2 = self:GetSequenceActivity(self:LookupSequence(death))
		elseif (dmginfo:IsDamageType(DMG_BUCKSHOT) && !string.find(self:GetModel(),"female") || string.find(self:GetModel(),"formal")) then
			death = table.Random(deathbyshotgunanimtbl)
			death2 = self:GetSequenceActivity(self:LookupSequence(death))
		end
		if (!dmginfo:IsDamageType(DMG_BUCKSHOT) and self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_01"))) then
			if (string.find(self:GetModel(),"female") and !string.find(self:GetModel(),"formal") and !string.find(self:GetModel(),"_tshirt_skirt") and !string.find(self:GetModel(),"_tanktop_jeans")) then
				death = table.Random(deathanimfemaletblrun)
				death2 = self:GetSequenceActivity(self:LookupSequence(death))
			else
				death = table.Random(deathanimtblrun)
				death2 = self:GetSequenceActivity(self:LookupSequence(death))
			end
			self.ContinueRunning = true
			--self.loco:SetDesiredSpeed(150)
			--self.loco:SetAcceleration(500)
		else
			if (dmginfo:IsDamageType(DMG_BUCKSHOT)) then
				self.ContinueRunning = true
				--self.loco:SetDesiredSpeed(150)
				--self.loco:SetAcceleration(500)
			else
				self.ContinueRunning = false
				--self.loco:SetDesiredSpeed(0)
				--self.loco:SetAcceleration(0)
			end
		end
		self.Ready = false
		self:PlaySequenceAndMove(self:LookupSequence(death))
		if (math.random(1,8) == 1 and !dmginfo:IsDamageType(DMG_BLAST) and !dmginfo:IsDamageType(DMG_BURN) and !dmginfo:IsDamageType(DMG_CRUSH) and !dmginfo:IsDamageType(DMG_CLUB) and !dmginfo:IsDamageType(DMG_DROWN) and !dmginfo:IsDamageType(DMG_SLASH)) then
			timer.Create("Dying"..self:EntIndex(), 0.2, 0, function()
				if (IsValid(self) and !self.PlayingSequence2) then
					self:BecomeRagdoll(dmginfo)
				end	
			end)
		else
			if (IsValid(self)) then
				self:BecomeRagdoll(dmginfo)
			end
		end		
		--self:BecomeRagdoll(dmginfo)
	end
end

if CLIENT then

	function ENT:Draw()
		if (LocalPlayer():GetPos():Distance(self:GetPos()) < 3200) then
			self:DrawModel()
		end
	end

end
list.Set( "NPC", "infected", {
	Name = "The Infected",
	Class = "infected",
	Category = "Left 4 Dead 2"
})
