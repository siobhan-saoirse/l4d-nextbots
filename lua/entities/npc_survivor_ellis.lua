if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
if CLIENT then
	language.Add("npc_survivor_nick", "Nick")
	language.Add("npc_survivor_rochelle", "Rochelle")
	language.Add("npc_survivor_coach", "Coach")
	language.Add("npc_survivor_ellis", "Ellis")
	language.Add("npc_survivor_bill", "Bill")
	language.Add("npc_survivor_zoey", "Zoey")
	language.Add("npc_survivor_louis", "Louis")
	language.Add("npc_survivor_francis", "Francis")
end
local function getAllInfected()
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.GetAll()) do
			if (v:GetClass() == "npc_boomer") then
				if (v:Health() > 1) then
					table.insert(npcs, v)
				end
			end
		end
	end 
	return npcs
end
local function randomSurvivor()
	local npcs = {}
		for k,v in ipairs(ents.GetAll()) do
			if (string.find(v:GetClass(),"survivor")) then
				table.insert(npcs, v) 
			end
		end
	return table.Random(npcs)
end
local function lookForNextPlayer(ply)
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), 120000 )) do
			
			if ((v:IsNPC() && v:Classify() != CLASS_PLAYER_ALLY || v:IsNextBot()) and v:GetPos() != nil and !string.find(v:GetClass(),"survivor") and !string.find(v:GetClass(),"director") and v:EntIndex() != ply:EntIndex()) then 
				if (IsValid(v)) then
					table.insert(npcs, v)
				end
			end
				
		end
	end
	return npcs 
end
local function nearestNPC(ply)
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), 500 )) do
			if (v:IsNPC() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex()) then
				if (v:Health() > 1) then
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
	return npcs
end


ENT.Base 			= "base_nextbot"
ENT.Type			= "nextbot"
ENT.Name			= "Survivor"
ENT.Spawnable		= false
ENT.IsAL4DZombie = true
ENT.AttackDelay = 50
ENT.AttackDamage = 4
ENT.AttackRange = 90
ENT.AttackRange2 = 300
ENT.RangedAttackRange = 200
ENT.IncapAmount = 0
ENT.AutomaticFrameAdvance = true
ENT.HaventLandedYet = false
ENT.Walking = false
ENT.IsRightArmCutOff = false
ENT.IsLeftArmCutOff = false
ENT.SurvivorName = "Mechanic"
ENT.WeaponModel = "models/w_models/weapons/w_rifle_ak47.mdl"

hook.Add("EntityEmitSound","SurvivorHearSound",function(snd)
	if (string.StartWith(snd.SoundName,"(")) then
		snd.SoundName = string.Replace(snd.SoundName, "(", ")")
		return true
	elseif (IsValid(snd.Entity)) then 
		if IsValid(snd.Entity) and snd.Entity:GetModel() and (string.StartWith(snd.Entity:GetClass(), "npc_survivor"))  and !string.find(snd.SoundName, "step") then
			if (string.find(snd.SoundName, "$survivor")) then
				snd.SoundName = string.Replace(snd.SoundName, "$survivor", string.lower(string.Replace(snd.Entity.SurvivorName,"Player.","")))
				return true
			end
			return true
		elseif IsValid(snd.Entity) and snd.Entity:GetModel() and (string.StartWith(snd.Entity:GetClass(), "npc_survivor"))  and string.find(snd.SoundName, "step") then
			snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
			snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
			snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
			snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
			snd.SoundName = string.Replace(snd.SoundName, "snow5", "snow1")
			snd.SoundName = string.Replace(snd.SoundName, "snow6", "snow2")
			snd.Channel = CHAN_STATIC //CHAN_BODY
			local speed = snd.Entity:GetVelocity():Length()
			local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
			snd.Volume = 1
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
				
			if (snd.Entity:WaterLevel() < 1) then  
				snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/survivor/run/")
				snd.Volume = 1
			elseif (snd.Entity:WaterLevel() < 2) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/survivor/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 1
			else
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/survivor/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 1
			end
			snd.Pitch = math.random(95,105)
			return true
		end
	end
end)

function ENT:Initialize()

	game.AddParticles( "particles/boomer_fx.pcf" )
	if SERVER then
		if (!self.DontReplaceModel) then
			self:SetModel( "models/survivors/survivor_"..string.Replace(string.Replace(self.SurvivorName,"Player.",""),"Teengirl","Teenangst")..".mdl" )
		end
	end
	self.LoseTargetDist	= 18200	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1800	-- How far to search for enemies
	self:SetHealth(100) 
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
		self:SetFOV(90)
		self:SetBloodColor(BLOOD_COLOR_RED)
		self:SetCollisionGroup(COLLISION_GROUP_NPC)
		self:AddFlags(FL_OBJECT)
		self:AddFlags(FL_CLIENT)
		self:SetSkin(math.random(0,self:SkinCount()-1))
		if SERVER then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() and v:Classify() != CLASS_PLAYER_ALLY and v:Classify() != CLASS_PLAYER_ALLY_VITAL then
					
					v:AddEntityRelationship(self,D_HT,99)
					
				end
			end
		end
		--self:SetBodygroup(0,math.random(1,2))
		--self:SetBodygroup(1,math.random(1,2))
		
		timer.Simple(0.1, function()
		
			self.Ready = true

		end)
					local axe = ents.Create("gmod_button")
					axe:SetModel(self.WeaponModel)
					axe:SetPos(self:GetPos())
					axe:SetAngles(self:GetAngles())
					axe:SetParent(self)
					axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.Weapon = axe
							if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then
								self.Clip = 30
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
								self.Clip = 30
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
								self.Clip = 50
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
								self.Clip = 10
							else
								self.Clip = 15
							end
	end	
end
function ENT:IsNPC()
	return true
end
function ENT:IsNextBot()
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

		if PointWithinViewAngle(self:EyePos(), pos:WorldSpaceCenter(), self:GetAimVector(), fov) then
			return true
		end

		return PointWithinViewAngle(self:EyePos(), pos:EyePos(), self:GetAimVector(), fov)
	else
		return PointWithinViewAngle(self:EyePos(), pos, self:GetAimVector(), fov)
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
	return util.QuickTrace(self:EyePos(), ply:EyePos() - self:EyePos(), {owner, self}).Entity == ply
end

function ENT:Shove(anim)
	self:EmitSound("BoomerZombie.Shoved")
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
			if isvector(options.multiply) then
				vec = Vector(vec.x*options.multiply.x, vec.y*options.multiply.y, vec.z*options.multiply.z)
			end
			vec:Rotate(self:GetAngles() + angles)
			self:SetAngles(self:LocalToWorldAngles(angles))
			if (self:IsOnGround()) then
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
function ENT:PlaySequenceAndWait2(seq, rate, callback)
	if isstring(seq) then seq = self:LookupSequence(seq)
	elseif not isnumber(seq) then return end
	if seq == -1 then return end
	local current = self:GetSequence()
	self.PlayingSequence2 = true
	self.PlayingSequence3 = true
	self:SetCycle(0)
	self:ResetSequence(seq)
	self:ResetSequenceInfo()
	self:SetPlaybackRate(1)
	local now = CurTime()
	self.lastCycle = -1
	self.callback = callback
	timer.Create("MoveAgain"..self:EntIndex(), self:SequenceDuration(seq) - 0.2, 1,function()
		self.PlayingSequence2 = false 
		self.PlayingSequence3 = false 
	end)
end
function ENT:PlayActivityAndMove(act, options, callback)
	if (act == -1) then ErrorNoHalt("What the FUCK why is there no ACT for this sequence???") return end
	local seq = self:SelectRandomSequence(act)
	return self:PlaySequenceAndMove(seq, options, callback)
end


function ENT:HandleStuck()
	--
	-- Clear the stuck status
	--
	if (IsValid(self:GetEnemy())) then
		local pos = self:FindSpot("near", {pos=self:GetEnemy():GetPos(),radius = 12000,type="hiding",stepup=800,stepdown=800})
		self:SetPos(pos)
	end
	self.loco:ClearStuck() 
end


function ENT:OnRemove()
	if SERVER then
		self:StopSound("BoomerZombie.Gurgle")
	end
	timer.Stop("IdleExpression"..self:EntIndex())
	timer.Stop("AngryExpression"..self:EntIndex())
	if (IsValid(self.bullseye)) then
		self.bullseye:Remove()
	end
end
----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	self.Enemy = ent
	if (ent != nil) then
		if (ent:IsPlayer() and (ent:IsFlagSet(FL_NOTARGET) or GetConVar("ai_ignoreplayers"):GetBool())) then return end
		if (ent:Health() > 0 and !self.Incap) then
			if (ent ~= self.Enemy) then
				if (math.random(1,5) == 1) then
					self:EmitSound(self.SurvivorName.."_LookOut0"..math.random(1,4))
				else
					if (math.random(1,5) == 1) then
						if (ent:GetClass() == "npc_boomer") then
							self:EmitSound(self.SurvivorName.."_WarnBoomer0"..math.random(1,3))
						elseif (ent:GetClass() == "npc_hunter_l4d") then
							self:EmitSound(self.SurvivorName.."_WarnHunter0"..math.random(1,3))
						elseif (ent:GetClass() == "npc_smoker") then
							self:EmitSound(self.SurvivorName.."_WarnSmoker0"..math.random(1,3))
						elseif (ent:GetClass() == "npc_tank") then
							self:EmitSound(self.SurvivorName.."_WarnTank0"..math.random(1,3))
						elseif (ent:GetClass() == "npc_jockey") then
							self:EmitSound(self.SurvivorName.."_WarnJockey0"..math.random(1,3))
						elseif (ent:GetClass() == "npc_spitter") then
							self:EmitSound(self.SurvivorName.."_WarnSpitter0"..math.random(1,3))
						elseif (ent:GetClass() == "npc_charger") then
							self:EmitSound(self.SurvivorName.."_WarnCharger0"..math.random(1,3))
						end
					end
				end
			end
		end
		self.Idling = false
	end
	if (math.random(1,20) == 1) then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() and v:Classify() != CLASS_PLAYER_ALLY then
					
					v:AddEntityRelationship(self,D_HT,99)
					v:SetEnemy(self)
					
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
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) and (self:GetEnemy():IsNPC() or self:GetEnemy():IsNextBot()) ) then
		-- If the enemy is too far
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			
			return self:FindEnemy()
		elseif (self:GetEnemy():Health() < 0) then
			return self:FindEnemy()
		end
		-- The enemy is neither too far nor too dead so we can return true
		return true
	else
		-- The enemy isn't valid so lets look for a new onethen
		if (self:IsOnGround() and self.Ready) then
			if (self:GetEnemy() != nil) then
				
						if (self:Health()*2<100) then

								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_PISTOL"))  ) 
								end

						else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SHOTGUN"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_PISTOL"))  ) 
								end
						end
			else
				--self:SetCycle(0)
				if (!self.Idling and !self.PlayingSequence3) then
					
					if (self:Health()*2<100) then
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_SMG"))  ) )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Injured_PumpShotgun"))  ) )
								else
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_PISTOL"))  ) )
								end
					else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_SMG"))  ) )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_SHOTGUN"))  ) )
								else
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_PISTOL"))  ) )
								end
					end
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
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = lookForNextPlayer(self)
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k,v in ipairs( _ents ) do

		if ( ( v:IsNPC() or v:IsNextBot()) and !v:IsFlagSet(FL_NOTARGET) and v:Health() > 0 ) then
			-- We found one so lets set it as our enemy and return tru
			self:SetEnemy(v)
			return true
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

hook.Add("EntityTakeDamage","L4D2BloodSplatterDamage",function(ent,dmginfo)
	--[[
	if (!dmginfo:IsDamageType(DMG_BURN) and !dmginfo:IsDamageType(DMG_BLAST) and !dmginfo:IsDamageType(DMG_DIRECT) and ent:IsTFPlayer()) then
		sound.Play( "player/survivor/splat/zombie_blood_spray_0"..math.random(1,6)..".wav", dmginfo:GetDamagePosition(), 55, math.random(95,105),0.3)
		for i=1,5 do
			timer.Simple(math.Rand(0.1,0.4), function() 
				sound.Play( "player/survivor/splat/zombie_blood_spray_0"..math.random(1,6)..".wav", dmginfo:GetDamagePosition(), 55, math.random(95,105),0.3)
			end)
		end
		
		local vec, tracedata, traceres = vec, tracedata, traceres

		tracedata.start = dmginfo:GetDamagePosition()
		tracedata.filter = ent

		local noise, count

		if dmg == 0 then
			noise, count = 0.1, 1
		elseif dmg == 1 then
			noise, count = 0.2, 2
		else
			noise, count = 0.3, 4
		end

		::loop::

		for i = 1, 3 do
			vec[i] = dmginfo:GetDamagePosition()[i] + (math.Rand(-noise, noise)) * 172
		end

		util.TraceLine(tracedata)

		if traceres.Hit then
			util.Decal("Blood", dmginfo:GetDamagePosition(), vec, ent)
		end

		if count > 1 then
			count = count - 1
	
			goto loop
		end
	elseif (!dmginfo:IsDamageType(DMG_BURN) and !dmginfo:IsDamageType(DMG_BLAST) and !dmginfo:IsDamageType(DMG_DIRECT) and ent:GetClass() == "prop_ragdoll") then
		sound.Play( "player/survivor/splat/zombie_blood_spray_0"..math.random(1,6)..".wav", dmginfo:GetDamagePosition(), 55, math.random(95,105),0.3)
		local effectdata = EffectData()
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		util.Effect( "BloodImpact", effectdata )
		for i=1,5 do
			timer.Simple(math.Rand(0.1,0.4), function()
				sound.Play( "player/survivor/splat/zombie_blood_spray_0"..math.random(1,6)..".wav", dmginfo:GetDamagePosition(), 55, math.random(95,105),0.3)
			end)
		end
		
		local vec, tracedata, traceres = vec, tracedata, traceres

		tracedata.start = dmginfo:GetDamagePosition()
		tracedata.filter = ent

		local noise, count

		if dmg == 0 then
			noise, count = 0.1, 1
		elseif dmg == 1 then
			noise, count = 0.2, 2
		else
			noise, count = 0.3, 4
		end

		::loop::

		for i = 1, 3 do
			vec[i] = dmginfo:GetDamagePosition()[i] + (math.Rand(-noise, noise)) * 172
		end

		util.TraceLine(tracedata)

		if traceres.Hit then
			util.Decal("Blood", dmginfo:GetDamagePosition(), vec, ent)
		end

		if count > 1 then
			count = count - 1
	
			goto loop
		end
	end]]

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
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if !self.ContinueRunning then 
			
			if ( !self.ContinueRunning and self:HaveEnemy() and !GetConVar("ai_disabled"):GetBool() ) then
				-- Now that we have an enemy, the code in this block will run
				if (self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_standing_rifle")) || self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_injured_rifle")) || self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_injured_PISTOL"))
				|| self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_standing_smg")) || self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_injured_smg"))
				|| self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle_standing_shotgun")) || self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("Idle_Injured_PumpShotgun"))) then
					self.PlayingSequence2 = false	
					self.PlayingSequence3 = false	
					
						if (self:Health()*2<100) then

								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_PISTOL"))  ) 
								end

						else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SHOTGUN"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_PISTOL"))  ) 
								end
						end
				end
				self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				if (!self.Incap and !self:GetNoDraw()) then
					self:ChaseEnemy()
				end
			else
				-- Since we can't find an enemy, lets wander
				if (self:GetCycle() == 1 and self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_rifle"))) then
					if (self:Health()*2<100) then
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_SMG"))  ) )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Injured_PumpShotgun"))  ) )
								else
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_PISTOL"))  ) )
								end
					else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_SMG"))  ) )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_SHOTGUN"))  ) )
								else
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_PISTOL"))  ) )
								end
					end
				end
			end
			coroutine.wait(0.01)
		
		elseif (self.ContinueRunning or self.PlayingSequence2) then

			if (self.ContinueRunning) then
				-- Now that we have an enemy, the code in this block will run
				--self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self.loco:Approach( self:GetEnemy():GetPos() ) -- Walk to a random place within about 400 units (yielding)
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
	if (self:IsOnGround() and (IsValid(self:GetEnemy()) and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0 and !self.PlayingSequence2 and !self.PlayingSequence3) then
			self:BodyMoveXY()
			-- BodyMoveXY() already calls FrameAdvance, calling it twice will affect animation playback, specifically on layers
			return
	end

	--
	-- If we're not walking or running we probably just want to update the anim system
	--
	self:FrameAdvance()

end

function ENT:Think()
	if SERVER then
		if (math.random(1,20) == 1) then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNextBot() and !string.find(v:GetClass(),"survivor") and self:Health() > 0 and v.AttackRange2 and v.AttackRange2 > 0 and v.Enemy == nil and v:SetEnemy(randomSurvivor()) then	
					
				end
			end
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() and v:Classify() != CLASS_PLAYER_ALLY then
					
					v:AddEntityRelationship(self,D_HT,99)
					
				end
			end
		end
	end
	if (self:GetNoDraw() == true) then
		self:SetMoveType(MOVETYPE_NONE)
	else
		self:SetMoveType(MOVETYPE_CUSTOM)
	end
	if (IsValid(self:GetEnemy()) and (self:GetEnemy():IsPlayer() or self:GetEnemy():IsNPC() or self:GetEnemy():IsNextBot()) and self:GetEnemy():Health() < 1) then
		self.Enemy = nil
		self:FindEnemy()
	end
	if (!IsValid(self:GetEnemy())) then
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),120)) do
			if (string.find(v:GetClass(),"survivor") and v.Incap and !v.GettingRevived and v:EntIndex() != self:EntIndex()) then
				v.GettingRevived = true
				if (v.IncapAmount > 2) then
					self:EmitSound(self.SurvivorName.."_ReviveCriticalFriend0"..math.random(1,3))
				else
					self:EmitSound(self.SurvivorName.."_ReviveFriend0"..math.random(1,9))
				end
				v:PlaySequenceAndMove("GetUpFrom_Incap")
				self:PlaySequenceAndMove("Heal_Incap_Crouching")
				timer.Simple(v:SequenceDuration(v:LookupSequence("GetUpFrom_Incap")) + 0.1, function()
					v.Incap = false
					v.Ready = true
					v.GettingRevived = false	
					v:SetHealth(30)
					v.Weapon:Remove()
					v.HaventLandedYet = true
					local axe = ents.Create("gmod_button")
					if (string.find(v:GetModel(),"coach") || string.find(v:GetModel(),"biker")) then
						axe:SetModel("models/w_models/weapons/w_autoshot_m4super.mdl")
					elseif (string.find(v:GetModel(),"namvet") || string.find(v:GetModel(),"gambler")) then
						axe:SetModel("models/w_models/weapons/w_rifle_m16a2.mdl")
					elseif (string.find(v:GetModel(),"teenangst") || string.find(v:GetModel(),"producer") || string.find(self:GetModel(),"manager")) then
						axe:SetModel("models/w_models/weapons/w_smg_uzi.mdl")
					elseif (string.find(v:GetModel(),"mechanic")) then
						axe:SetModel("models/w_models/weapons/w_rifle_ak47.mdl")
					else
						axe:SetModel("models/w_models/weapons/w_desert_eagle.mdl")
					end
					axe:SetPos(v:GetPos())
					axe:SetAngles(v:GetAngles())
					axe:SetParent(v)
					axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					v.Weapon = axe
					v:EmitSound(v.SurvivorName.."_Thanks0"..math.random(1,5))
				end)
			end
		end
			if (!self.Incap and !self.GettingRevived and self:Health()*2<100 and (!self.NextHeal or CurTime() > self.NextHeal)) then
				self.GettingRevived = true
				self:PlaySequenceAndMove("Heal_Self_Standing_06")
				self.NextHeal = CurTime() + 30
				self:EmitSound("Player.BandagingWounds")
				self.Ready = false
				self.Weapon:Remove()
				timer.Simple(self:SequenceDuration(self:LookupSequence("Heal_Self_Standing_06")) + 0.1, function()
					self:SetHealth(100)
					self.IncapAmount = 0
					local axe = ents.Create("gmod_button")
					if (string.find(self:GetModel(),"coach") || string.find(self:GetModel(),"biker")) then
						axe:SetModel("models/w_models/weapons/w_autoshot_m4super.mdl")
					elseif (string.find(self:GetModel(),"namvet") || string.find(self:GetModel(),"gambler")) then
						axe:SetModel("models/w_models/weapons/w_rifle_m16a2.mdl")
					elseif (string.find(self:GetModel(),"teenangst") || string.find(self:GetModel(),"producer") || string.find(self:GetModel(),"manager")) then
						axe:SetModel("models/w_models/weapons/w_smg_uzi.mdl")
					elseif (string.find(self:GetModel(),"mechanic")) then
						axe:SetModel("models/w_models/weapons/w_rifle_ak47.mdl")
					else
						axe:SetModel("models/w_models/weapons/w_desert_eagle.mdl")
					end
					axe:SetPos(self:GetPos())
					axe:SetAngles(self:GetAngles())
					axe:SetParent(self)
					axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.Weapon = axe
					self.Incap = false
					self.Ready = true
					self.GettingRevived = false	
					if (string.find(self.SurvivorName,"Player.")) then
						self:EmitSound(self.SurvivorName.."_PainReliefSigh0"..math.random(1,6))
					else
						self:EmitSound(self.SurvivorName.."_PainRelieftFirstAid0"..math.random(1,9))
					end
					self.HaventLandedYet = true
				end)
			end
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
	if SERVER then 
		if (IsValid(self:GetEnemy())) then
			local bound1, bound2 = self:GetCollisionBounds()
			self:DirectPoseParametersAt(self:GetEnemy():GetPos() + Vector(0,0,math.max(bound1.z, bound2.z) - 30), "body", self:EyePos())
		end
		if (self.Idling and self:GetCycle() == 1 and !self.PlayingSequence3 and IsValid(self.Weapon)) then
			self:SetCycle(0)
			local mad = self:GetSequenceActivity(self:LookupSequence("Idle_Standing_Rifle"))
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									mad = self:GetSequenceActivity(self:LookupSequence("idle_standing_SMG")) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									mad = self:GetSequenceActivity(self:LookupSequence("idle_standing_SHOTGUN"))
								else
									mad = self:GetSequenceActivity(self:LookupSequence("idle_standing_PISTOL"))
								end
			local mad2 = self:SelectRandomSequence(mad) 
			self:ResetSequence( mad2 )
		end
		if (!self:IsOnGround() and !self.Incap) then
			if (!self.HaventLandedYet) then 
				self:SetCycle(0)
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("jump_Rifle_01"))  )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("jump_Rifle_01"))  )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("jump_SMG_01"))  )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("jump_SHOTGUN_01"))  )
								else
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("jump_PISTOL_01"))  )
								end

				self.FallDamage = 0;
				timer.Create("BurpWhileFalling"..self:EntIndex(), 1.0, 0, function()
					if (!self:IsOnGround() and !self.Incap) then
						if (!self.Falling) then
							self.Falling = true
							self:StartActivity(self:GetSequenceActivity(self:LookupSequence("Idle_Falling")))
							self:EmitSound("Player.Fall")
						end
						self.FallDamage = self.FallDamage + 40

					end
				end)
				self.HaventLandedYet = true
			end
		else
			if (self.HaventLandedYet) then
				self:AddGestureSequence(self:LookupSequence("Jump_Land_gesture"))
				if (self:IsOnGround() and self.Ready) then
					if (self:GetEnemy() != nil) then
						if (self:Health()*2<100) then

								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_PISTOL"))  ) 
								end

						else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SHOTGUN"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_PISTOL"))  ) 
								end
						end
					else
						--self:SetCycle(0)
					if (self:Health()*2<100) then
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_SMG"))  ) )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_PUMPSHOTGUN"))  ) )
								else
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_injured_PISTOL"))  ) )
								end
					else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_Rifle"))  ) )
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_SMG"))  ) )
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_SHOTGUN"))  ) )
								else
									self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle_standing_PISTOL"))  ) )
								end
					end
					end
				end
				if (self.FallDamage and self.FallDamage > 0) then
					local dmginfo = DamageInfo()
					dmginfo:SetDamageType(DMG_FALL)
					dmginfo:SetDamage(self.FallDamage)
					self:TakeDamageInfo(dmginfo)
					self:EmitSound("Player.FallDamage")
				else
					self:EmitSound("Player.JumpLand")
				end
				self.Falling = false
				self.HaventLandedYet = false
				self.PlayingSequence2 = false
				self.PlayingSequence3 = false
			end
		end
		if (self.Ready and !self.PlayingSequence3 and self:GetCycle() == 0 and self:GetActivity() == -1 and !(self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_rifle")) && self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("limprun_rifle")))) then
			self:PlayActivityAndWait( self:GetActivity() )
		elseif (self.Ready and !self.PlayingSequence3 and !self.Idling and self:GetEnemy() == nil and (self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_rifle")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("limprun_rifle")))) then 

			local mad = self:GetSequenceActivity(self:LookupSequence("Idle_Standing_Rifle"))
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									mad = self:GetSequenceActivity(self:LookupSequence("idle_standing_SMG"))
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									mad = self:GetSequenceActivity(self:LookupSequence("idle_standing_SHOTGUN")) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									mad = self:GetSequenceActivity(self:LookupSequence("idle_standing_PISTOL"))
								end
			local mad2 = self:SelectRandomSequence(mad) 
			self:StartActivity( mad )
			self.Idling = true
		end
		if (!GetConVar("ai_disabled"):GetBool() and self.Ready) then
			if (math.random(1,4) == 1) then
				for k,v in ipairs(ents.FindByClass("l4d2_ai_director")) do
					if (IsValid(v)) then
						if (table.Count(getAllInfected()) > 30) then
							self:Remove()
						end
					end
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
			if (IsValid(self.AvoidingEntity) and self.AvoidingEntity:GetPos():Distance(self:GetPos()) > 120 ) then
				self.AvoidingEntity = nil
				self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			end
		end
	end 
	if SERVER then
		if (!GetConVar("ai_disabled"):GetBool()) then
			if (IsValid(self.Door) and self:IsOnGround() and self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
				self.loco:SetDesiredSpeed( 0 )
				self.loco:SetAcceleration(-270)
			end
			if (!IsValid(self.Door) and self.WasAttackingDoor) then

				self.Ready = true
				self:SetCollisionGroup(COLLISION_GROUP_NPC)
				self.WasAttackingDoor = false

			end
			if (self.PlayingSequence2) then
				self:SetPlaybackRate(1)
			end
				if (self.Clip < 1) then
					if (!self.ReloadTime || self.ReloadTime and CurTime() > self.ReloadTime) then
							if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then
								self:AddGestureSequence(self:LookupSequence("Reload_Standing_Rifle"))
								self.ReloadTime = CurTime() + 3.0
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
								self:AddGestureSequence(self:LookupSequence("Reload_Standing_Rifle"))
								self.ReloadTime = CurTime() + 3.0
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
								self:AddGestureSequence(self:LookupSequence("Reload_Standing_SMG"))
								self.ReloadTime = CurTime() + 3.5
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
								self:AddGestureSequence(self:LookupSequence("Reload_Standing_Shotgun_start"))
								timer.Create("ReloadLoop"..self:EntIndex(), 0.4, 8, function()
									self:AddGestureSequence(self:LookupSequence("Reload_Standing_Shotgun_loop"..math.random(1,3)))
								end)
								timer.Create("ReloadFinish"..self:EntIndex(), 3.8, 1, function()
									self:AddGestureSequence(self:LookupSequence("Reload_Standing_Shotgun_end"))
									timer.Simple(1, function()
										self.Clip = 10
									end)
								end)
								self.ReloadTime = CurTime() + 3.8
							else
								self:AddGestureSequence(self:LookupSequence("Reload_Standing_Pistol"))
								self.ReloadTime = CurTime() + 3.0
							end
						timer.Simple(3.0, function()
						
							if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then
								self.Clip = 30
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
								self.Clip = 30
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
								self.Clip = 50
							else
								self.Clip = 7
							end
							
							
						end)
					end
				end
				if (self:GetMoveType() != MOVETYPE_NONE and IsValid(self:GetEnemy()) and self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 + 1000 or self.PlayingSequence and !self.ContinueRunning) then
					if ((!self.FireTime || self.FireTime and CurTime() > self.FireTime) and self.Clip > 0 and IsValid(self.Weapon) and self:GetEnemy():Visible(self)) then
						if (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
							for i=1,8 do
							
								self.Weapon:FireBullets({
									Attacker = self,
									Num = 1,
									Dir = ((self:GetEnemy():GetPos()) - self:EyePos()) + Vector(math.Rand(-60,60),math.Rand(-60,60),math.Rand(-60,60)),
									Src = self:GetPos() + Vector(0,0,20) * 4,
									Spread = Vector(math.Rand(-8,8),math.Rand(-8,8),math.Rand(-8,8)),
									Damage = 2
								})
								
							end
						else
							self.Weapon:FireBullets({
								Attacker = self,
								Num = 1,
								Dir = ((self:GetEnemy():GetPos()) - self:EyePos()) + Vector(math.Rand(-5,5),math.Rand(-5,5),math.Rand(-5,5)),
								Src = self:GetPos() + Vector(0,0,20) * 4,
								Spread = Vector(math.Rand(-5,5),math.Rand(-5,5),math.Rand(-5,5)),
								Damage = 15
							})
						end
						if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then
							self:AddGestureSequence(self:LookupSequence("Shoot_Standing_RIFLE"))
							self.Weapon:EmitSound("AK47.Fire")
							self.FireTime = CurTime() + 0.12
						elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
							self:AddGestureSequence(self:LookupSequence("Shoot_Standing_RIFLE"))
							self.Weapon:EmitSound("Rifle.Fire")
							self.FireTime = CurTime() + 0.08
						elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
							self:AddGestureSequence(self:LookupSequence("Shoot_Standing_SMG"))
							self.Weapon:EmitSound("SMG.Fire")
							self.FireTime = CurTime() + 0.06
						elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
							self:AddGestureSequence(self:LookupSequence("Shoot_Standing_xm1014"))
							self.Weapon:EmitSound("AutoShotgun.Fire")
							self.FireTime = CurTime() + 0.28
						else
							self:AddGestureSequence(self:LookupSequence("Shoot_Standing_Pistol"))
							self.Weapon:EmitSound("Pistol.Fire")
							self.FireTime = CurTime() + 0.35
						end
						self.Clip = self.Clip - 1
					end
				end
			if (!self.Incap and self:GetMoveType() != MOVETYPE_NONE and IsValid(self:GetEnemy()) and self:IsOnGround() and !self.PlayingSequence3 and !self.PlayingSequence2) then
				if (!self.PlayingSequence3 and !self.ContinueRunning and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 and self:GetEnemy():Health() > 0) then
					local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
					if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay || CurTime() > self.MeleeAttackDelay)) then
						if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange) then
							if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange) then
								self:SetCollisionGroup(COLLISION_GROUP_NPC)
							end
							self:EmitSound("Weapon.Swing")
							local selanim = self:LookupSequence(table.Random({"Melee_Sweep_Running_Rifle","Melee_Sweep_Running_Rifle_02","Melee_Sweep_Running_Rifle_03","Melee_Straight_Running_Rifle","Melee_Shove_Standing_Rifle",}))
							local anim = self:GetSequenceActivity(selanim)
							self.MeleeAttackDelay = CurTime() + 0.7
							self:AddGesture(anim)
							self.loco:ClearStuck() 
							timer.Simple(0.2, function()
								for k,v in ipairs(ents.FindInSphere(self:GetPos(),self.AttackRange)) do
									
									if (IsValid(v) and (v:IsPlayer() or (v:IsNextBot()) or v:IsNPC()) and !string.find(v:GetClass(),"survivor") and !v.PlayingSequence3 and !v.PlayingSequence2) then
										self:EmitSound(
											"Weapon.HitInfected",
											85, 100
										)
										local dmginfo = DamageInfo()
										dmginfo:SetAttacker(self)
										dmginfo:SetInflictor(self)
										dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH))
										dmginfo:SetDamage(5)
										if (GetConVar("skill"):GetInt() > 1) then
											dmginfo:ScaleDamage(1 + (GetConVar("skill"):GetInt() * 0.65))
										end
										v:TakeDamageInfo(dmginfo) 
									end

								end
								
							end)
							self.DontWannaUseSameSequence = false
						end
					end
				end
				if (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 + 150 and self:GetEnemy():Health() > 0 or self.PlayingSequence and !self.ContinueRunning) then
					if (self:GetEnemy():GetClass() == "npc_tank" or self:GetEnemy():GetClass() == "npc_tank_vs" or self:GetEnemy():GetClass() == "npc_boomer" or self:GetEnemy():GetClass() == "npc_charger") then
						if (self:Health()*2<100) then
							self.loco:SetDesiredSpeed(210 * self:GetModelScale() * 0.65)
							self.loco:SetAcceleration(-500 * self:GetModelScale())
						else
							self.loco:SetDesiredSpeed(210 * self:GetModelScale())
							self.loco:SetAcceleration(-500 * self:GetModelScale())
						end
					end 
				elseif (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 and self:GetEnemy():Health() > 0 or self.PlayingSequence and !self.ContinueRunning) then
					self.loco:SetDesiredSpeed( 0 )
					self.loco:SetAcceleration(500)
					self:SetPoseParameter("move_x",0)
					self:SetPoseParameter("move_y",0)
					self.loco:ClearStuck() 
				elseif (!self.Incap and self:GetMoveType() != MOVETYPE_NONE and !self.ContinueRunning and self:IsOnGround() and (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0) then
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then
						if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay || CurTime() > self.MeleeAttackDelay)) then
							if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then
								self:SetCollisionGroup(COLLISION_GROUP_NPC)
							end
							self:EmitSound("Weapon.Swing")
							local selanim = self:LookupSequence(table.Random({"Melee_Sweep_Running_Rifle","Melee_Sweep_Running_Rifle_02","Melee_Sweep_Running_Rifle_03","Melee_Straight_Running_Rifle","Melee_Shove_Standing_Rifle",}))
							local anim = self:GetSequenceActivity(selanim)
							self.MeleeAttackDelay = CurTime() + 0.7
							self:AddGesture(anim)
							self.loco:ClearStuck() 
							self.DontWannaUseSameSequence = false
							timer.Simple(0.2, function()
								for k,v in ipairs(ents.FindInSphere(self:GetPos(),self.AttackRange2)) do
									
									if (IsValid(v) and (v:IsPlayer() or (v:IsNextBot()) or v:IsNPC()) and !string.find(v:GetClass(),"survivor") and !v.PlayingSequence3 and !v.PlayingSequence2) then
										self:EmitSound(
											"Weapon.HitInfected",
											85, 100
										)
										local dmginfo = DamageInfo()
										dmginfo:SetAttacker(self)
										dmginfo:SetInflictor(self)
										dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH))
										dmginfo:SetDamage(8)
										if (GetConVar("skill"):GetInt() > 1) then
											dmginfo:ScaleDamage(1 + (GetConVar("skill"):GetInt() * 0.65))
										end
										v:TakeDamageInfo(dmginfo) 
									end

								end
								
							end)
						end
					elseif (self.Ready) then						
							if (self:Health()*2<100) then
								self.loco:SetDesiredSpeed(210 * self:GetModelScale() * 0.65)
								self.loco:SetAcceleration(500 * self:GetModelScale())
							else
								self.loco:SetDesiredSpeed(210 * self:GetModelScale())
								self.loco:SetAcceleration(500 * self:GetModelScale())
							end
					end
				end
			end
		end
		if (self.ContinueRunning or self.PlayingSequence2) then
			self.PlayingSequence = false
		end
	end
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
	path:SetMinLookAheadDistance( 175 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position
	
	if ( !path:IsValid() ) then return "failed" end

	if (self:Health() > 0 and !self.HaventLandedYet and !self.EncounteredEnemy and !self.PlayingSequence and !self.PlayingSequence2) then 
		self.EncounteredEnemy = true
	end
	while ( path:IsValid() and IsValid(self:GetEnemy()) and !self.ContinueRunning and !self.PlayingSequence and !self.PlayingSequence3 and !self.PlayingSequence2 ) do
		if (!self.PlayingSequence3 and self:GetCycle() == 1 and self:GetSequence() != self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_rifle"))) and !(self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_rifle")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("limprun_rifle")))) then  
			if (self.loco:IsUsingLadder()) then
				self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  ) )			-- Set the animation
			else
				
						if (self:Health()*2<100) then

								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:ResetSequence( self:GetSequenceActivity(self:LookupSequence("LimpRun_Rifle"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("LimpRun_PISTOL"))  ) 
								end

						else
								if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
									
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SMG"))  ) 
									
								elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SHOTGUN"))  ) 
								else
									self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_PISTOL"))  ) 
								end
						end
			end
		end 
		local pos = self:GetEnemy():GetPos()
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(),180)) do -- avoid other infected
				if (v:GetClass() == "npc_boomer" and v:EntIndex() != self:EntIndex()) then
					--pos = self:GetEnemy():GetPos() + (self:GetForward() + v:GetForward()*(-130)) + (v:GetRight() * -130 - self:GetRight()*(130))
					self:SetCollisionGroup(COLLISION_GROUP_NPC)
				end
			end
		end
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),120)) do
			if (v ~= self and IsValid(v) and (v.IsInfected or v:GetClass() == "npc_boomer")) then
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
	if (dmginfo:GetDamage() > self:Health() - 1 and !self.Incap and self.IncapAmount < 3 and !dmginfo:IsDamageType(DMG_FALL)) then
		dmginfo:SetDamage(0)
		self:EmitSound(string.Replace(self.SurvivorName,"Player.","npc.").."_IncapacitatedInitial0"..math.random(1,3))
		self.PainSoundTime = CurTime() + 1.5
		self.IncapAmount = self.IncapAmount + 1
		self.Clip = 15
		self:SetHealth(300)
		local death = table.Random({"Death"})
		local death2 = self:GetSequenceActivity(self:LookupSequence(death))
		self.Ready = false
		self.Weapon:Remove()
		self:PlaySequenceAndMove(self:LookupSequence(death))
		timer.Simple(self:SequenceDuration(self:LookupSequence(death)), function()
			self:ResetSequence("Idle_Incap_Pistol")
		end)
					local axe = ents.Create("gmod_button")
					axe:SetModel("models/w_models/weapons/w_pistol_a.mdl")
					axe:SetPos(self:GetPos())
					axe:SetAngles(self:GetAngles())
					axe:SetParent(self)
					axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.Weapon = axe
		self.Incap = true
	end
	if ((!self.PainSoundTime or CurTime() > self.PainSoundTime)) then
		if (self.Incap) then
			if (self:GetNoDraw() == true) then
				self:EmitSound(self.SurvivorName.."_ScreamWhilePounced0"..math.random(1,7)) 
				self.PainSoundTime = CurTime() + 1.5
			else
				if (string.find(dmginfo:GetAttacker():GetClass(),"tank")) then
					self:EmitSound(self.SurvivorName.."_TankPound0"..math.random(1,6))	
				else
					self:EmitSound(self.SurvivorName.."_IncapacitatedInjury0"..math.random(1,3))
				end
				self.PainSoundTime = CurTime() + 2.0
			end
		else
			if ((string.find(dmginfo:GetAttacker():GetClass(),"survivor") or dmginfo:GetAttacker():IsPlayer()) and !self.Incap) then
				self:EmitSound(self.SurvivorName.."_FriendlyFire"..table.Random({"01","02","03","04","05","06","07","08","09"}))
			else
				if (self:GetNoDraw() == true) then
				self:EmitSound(self.SurvivorName.."_ScreamWhilePounced0"..math.random(1,7)) 
				else
					if (self:Health()*2<100) then
						self:EmitSound(self.SurvivorName.."_HurtCritical0"..math.random(1,9))
					else
						if (dmginfo:GetDamage() > 20) then
							self:EmitSound(self.SurvivorName.."_HurtMajor0"..math.random(1,6))
						else
							self:EmitSound(self.SurvivorName.."_HurtMinor0"..math.random(1,6))
						end
					end
				end
			end
			self.PainSoundTime = CurTime() + 1.5
		end
	end
	if ((string.find(dmginfo:GetAttacker():GetClass(),"survivor") or dmginfo:GetAttacker():IsPlayer()) and !self.Incap) then
		dmginfo:ScaleDamage(0.1)
	end
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
	if (dmginfo:GetAttacker() != nil and (dmginfo:GetAttacker():IsNPC() || dmginfo:GetAttacker():IsNextBot() && !string.find(dmginfo:GetAttacker():GetClass(),"npc_survivor"))) then 
		self:SetEnemy(dmginfo:GetAttacker())
	end
	if (!self.Incap and (dmginfo:IsDamageType(DMG_BLAST) or string.find(dmginfo:GetAttacker():GetClass(),"npc_tank")) and !self.PlayingSequence2 and !self.PlayingSequence) then
		local selanim = table.Random({"Shoved_Backward","Shoved_Forward","Shoved_Leftward","Shoved_Rightward"})
		local anim = self:LookupSequence(selanim)
		self:PlaySequenceAndMove(anim)
		timer.Stop("ShovedFinish"..self:EntIndex())
		timer.Create("ShovedFinish"..self:EntIndex(), self:SequenceDuration(anim) - 0.2, 1,function()
			if (self:IsOnGround() and self.Ready) then
				if (self:GetEnemy() != nil) then
					if (self:Health()*2<100) then

						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("limprun_rifle"))  ) )			-- Set the animation

					else
							if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_Rifle"))  ) 
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
								
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SMG"))  ) 
								
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_SHOTGUN"))  ) 
							else
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Run_PISTOL"))  ) 
							end
					end
				else
					--self:SetCycle(0)
							if (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_ak47.mdl") then											
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Standing_Rifle"))  ) )
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Idle_Standing_Rifle"))  ) 
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_rifle_m16a2.mdl") then
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Idle_Standing_Rifle"))  ) 
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Standing_Rifle"))  ) )
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_smg_uzi.mdl") then
								
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Standing_SMG"))  ) )
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Idle_Standing_SMG"))  ) 
								
							elseif (self.Weapon:GetModel() == "models/w_models/weapons/w_autoshot_m4super.mdl") then
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Standing_SHOTGUN"))  ) )
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Idle_Standing_SHOTGUN"))  ) 
							else
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Idle_Standing_PISTOL"))  ) )
								self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("Idle_Standing_PISTOL"))  ) 
							end
				end
			end
		end)
	end
	if (dmginfo:GetAttacker():GetClass() == "entityflame" or dmginfo:GetAttacker():GetClass() == "tf_entityflame") then
		dmginfo:GetAttacker():StopSound("General.BurningObject")
	end
	if (!self.flinchFinish) then
		self:AddGesture(self:GetSequenceActivity(self:LookupSequence("flinch_0"..math.random(1,3))),true)
		self.flinchFinish = true
		timer.Create("FlinchFinished"..self:EntIndex(), self:SequenceDuration(self:LookupSequence("flinch_02")), 1, function()
			self.flinchFinish = false
		end)
	end
	if (dmginfo:IsDamageType(DMG_BULLET) and self:Health() > 0) then
		if (math.random(1,6) == 1) then
			self:EmitSound("BoomerZombie.BulletImpact")
		end
	end
	if (!self.Incap and !dmginfo:IsDamageType(DMG_CLUB) and !string.find(dmginfo:GetAttacker():GetClass(),"hunter")) then
		dmginfo:ScaleDamage(0.4)
	elseif (self.Incap) then
		dmginfo:ScaleDamage(2)
	end
end
function ENT:Touch( entity )
end
local deathanimfemaletbl = 
{

	"death",

}
local deathbyshotgunanimtbl = 
{

	"death",

}
local deathanimtbl = 
{

	"death",

}

local deathanimfemaletblrun = 
{

	"Death_Running_07",
	
}
local deathanimtblrun = 
{

	"Death_Running_07",
	
}

function ENT:OnKilled( dmginfo )
	
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local pos = self:GetPos()
	self:PrecacheGibs()
	if SERVER then

		self.Ready = false
		self.Weapon:Remove()
		self:BecomeRagdoll(dmginfo)
		timer.Simple(0.1, function()
			self:Remove()
		end)
		 
	end
end
 
if CLIENT then

	function ENT:Draw()
		if (LocalPlayer():GetPos():Distance(self:GetPos()) < 3200 and !self:GetNoDraw()) then
			self:DrawModel()
		end
	end

end 
list.Set( "NPC", "ellis", {
	Name = "Ellis",
	Class = "npc_survivor_ellis",
	Category = "Left 4 Dead 2 - Survivors"
})
