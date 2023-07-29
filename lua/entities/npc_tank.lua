if (!IsMounted("left4dead2")) then return end

AddCSLuaFile()
if CLIENT then
	language.Add("npc_tank", "Tank")
end
local function getAllInfected()
	local npcs = {}
	if (math.random(1,16) == 1) then
		for k,v in ipairs(ents.GetAll()) do
			if (v:GetClass() == "npc_tank") then
				if (v:Health() > 1) then
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
		local range = 1210
		if (ply.IsVersus) then
			range = 12000
		end
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), range )) do
			
			if (engine.ActiveGamemode() == "teamfortress") then
				if (v:IsTFPlayer() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex() and ply:Visible(v)) then
					if (v:Health() > 1) then
						table.insert(npcs, v)
					end
				end
			else
				if (!ply.IsVersus) then

					if ((v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() || v:IsNPC()) and !v:IsNextBot() and v:GetClass() != "npc_tank"  and v:GetClass() != "infected" and v:EntIndex() != ply:EntIndex() and ply:Visible(v)) then
						if (v:Health() > 1) then
							table.insert(npcs, v)
						end
					end

				else

					if ((v:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool() || v:IsNPC()) and !v:IsNextBot() and v:GetClass() != "npc_tank"  and v:GetClass() != "infected" and v:EntIndex() != ply:EntIndex() ) then
						if (v:Health() > 1) then
							table.insert(npcs, v)
						end
					end

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
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(),190)) do
			if (((v:GetClass() == "prop_door_rotating" and v:GetPos():Distance(ply:GetPos()) < 70) or v:GetClass() == "prop_physics") ) then
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
ENT.Name			= "Tank"
ENT.Spawnable		= false
ENT.AttackDelay = 50
ENT.AttackDamage = 30
ENT.AttackRange = 100
ENT.AttackRange2 = 190
ENT.RangedAttackRange = 600
ENT.AutomaticFrameAdvance = true
ENT.HaventLandedYet = false
ENT.Walking = false
ENT.IsRightArmCutOff = false
ENT.IsLeftArmCutOff = false
ENT.IsVersus = false
local modeltbl = {
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk.mdl",
	"models/infected/hulk_l4d1.mdl",
	"models/infected/hulk_dlc3.mdl",
}
local MusicTable = {
	"Event.Tank",
	"Event.TankMidpoint",
}

hook.Add("EntityEmitSound","TankHearSound",function(snd)
	if (IsValid(snd.Entity)) then 
		if IsValid(snd.Entity) and snd.Entity:GetModel() and string.StartWith(snd.Entity:GetModel(), "models/infected/hulk") and string.find(snd.SoundName, "step") then
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
				if (snd.Entity:WaterLevel() < 1) then
						
					if (!string.find(snd.Entity:GetSequenceName(snd.Entity:GetSequence()),"run_")) then
						snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk0"..math.random(1,6)..".wav")
						snd.Channel = CHAN_BODY
						snd.Volume = 0.85
						snd.SoundLevel = 95
					else
						snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk0"..math.random(1,6)..".wav")
						snd.Channel = CHAN_BODY
						snd.Volume = 0.5
						snd.SoundLevel = 95
					end

				elseif (snd.Entity:WaterLevel() < 2) then
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk_water_0"..math.random(1,6)..".wav")
					snd.Channel = CHAN_STATIC
					snd.Volume = 0.5
					snd.SoundLevel = 95
				else
					snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk_water_0"..math.random(1,6)..".wav")
					snd.Channel = CHAN_STATIC
					snd.Volume = 0.5
					snd.SoundLevel = 95
				end
			snd.Pitch = math.random(95,105)
			return true
		end
		if ((snd.Entity:IsPlayer() && !GetConVar("ai_ignoreplayers"):GetBool()  || snd.Entity:IsNPC()) and !snd.Entity:IsNextBot() and snd.Entity:GetClass() != "infected") then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),6000)) do
				if (v:GetClass() == "npc_tank" and !IsValid(v:GetEnemy()) and v.Ready and !v.ContinueRunning and !v:IsOnFire() and !snd.Entity:IsFlagSet(FL_NOTARGET) and snd.Entity:Visible(v)) then
					v:SetEnemy(snd.Entity)
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
	self:EmitSound("HulkZombie.Shoved")
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
	bound2.z = self.loco:GetStepHeight()
	trdata.start = data.start or self:GetPos()
	trdata.endpos = data.endpos or trdata.start + vec
	trdata.collisiongroup = data.collisiongroup or self:GetCollisionGroup()
	trdata.filter = data.filter or self
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

function ENT:Initialize()

	game.AddParticles( "particles/tank_fx.pcf" )
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
		end
	end
	self.LoseTargetDist	= 3200	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1800	-- How far to search for enemies
	self:SetHealth(4000) 
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
		self:SetBloodColor(BLOOD_COLOR_RED)
		self:SetCollisionGroup(COLLISION_GROUP_NPC)
		self:AddFlags(FL_OBJECT)
		self:AddFlags(FL_NPC)
		self:SetSkin(math.random(0,self:SkinCount()-1))
		self.Music = CreateSound( self, table.Random(MusicTable), filter ) -- create the new sound, parented to the worldspawn (which always exists)
		self.Music:PlayEx(1.0,100)
		self.Music:FadeOut(0.01)
		for k,v in ipairs(ents.FindByClass("l4d2_ai_director")) do
			if (IsValid(v)) then
				if (table.Count(getAllInfected()) > 30) then
					self:Remove()
				end
			end
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
		
		local mad = self:GetSequenceActivity(self:LookupSequence("idle"))
		self:StartActivity( mad )
		timer.Simple(1, function()
		
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
		if (self.IsVersus) then
			for k,v in ipairs(ents.FindByClass("npc_tank")) do
				v.Music:Stop()
			end
			self.Music:PlayEx(1.0,100)
			if (!self.MusicPlayed) then
				self.MusicPlayed = true
			end
		end
	end	
	timer.Create("PlaySomeIdleSounds"..self:EntIndex(), math.random(2,10), 0, function()
	
		if (self.Ready) then 
			if (!GetConVar("ai_disabled"):GetBool()) then
				if (IsValid(self:GetEnemy())) then
					self:EmitSound("HulkZombie.Yell",75,math.random(95,105),1,CHAN_VOICE)
				else
					self:EmitSound(table.Random({"HulkZombie.Breathe"}))
				end
			end
		end

	end)
end

function ENT:HandleStuck()
	--
	-- Clear the stuck status
	--
	--[[
	if (IsValid(self:GetEnemy())) then
		local pos = self:FindSpot("near", {pos=self:GetEnemy():GetPos(),radius = 12000,type="hiding",stepup=800,stepdown=800})
		self:SetPos(pos)
	end]]
	local dmginfo = DamageInfo()
	dmginfo:SetAttacker(self)
	dmginfo:SetInflictor(self)
	dmginfo:SetDamageType(DMG_CRUSH)
	dmginfo:SetDamage(self:Health())
	self:OnKilled(dmginfo)
	self.loco:ClearStuck() 
end


function ENT:OnRemove()
	if SERVER then
		self.Music:Stop()
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
	if (ent != nil and ent:IsNextBot()) then return end
	self.Enemy = ent
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
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif (self:GetEnemy():IsNextBot()) then
			return self:FindEnemy()
		elseif (engine.ActiveGamemode() == "teamfortress") then
			if ( self:GetEnemy():IsTFPlayer() and (GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_SPECTATOR or GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_FRIENDLY or self:GetEnemy():Health() < 1 or self:GetEnemy():IsFlagSet(FL_NOTARGET)) ) then
				return self:FindEnemy()
			end	 
		elseif (self:GetEnemy():Health() < 1 or self:GetEnemy():IsFlagSet(FL_NOTARGET) or (self:GetEnemy():IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool())) then
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
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
				end
			else
				--self:SetCycle(0)
				if (!self.Idling and !self.PlayingSequence3) then
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle"))  ) )
					self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle"))  ) 
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
					--self:EmitSound("HulkZombie.RageAtVictim")
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

				if ( ( v:IsPlayer() or v:IsNPC()) and !v:IsNextBot() and v:GetClass() != "npc_tank"  and v:GetClass() != "infected" and v:Health() > 0 and !v:IsFlagSet(FL_NOTARGET) ) then
					-- We found one so lets set it as our enemy and return true
					self:SetEnemy(v)
					--self:EmitSound("HulkZombie.RageAtVictim")
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

							npc:SetEnemy(self)

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
	if (event == 3002) then	
			for k,v in ipairs(ents.FindByName("DebrisModel"..self:EntIndex())) do
				v:Remove()
			end
			self:EmitSound("HulkZombie.Throw")
			local p = ents.Create("base_anim")
			p:SetModel("models/props_debris/concrete_chunk06c.mdl")
			p:SetBodygroup(1, 1)
			p:SetPos(self:GetPos() + Vector(0,0,80))
			p:SetAngles(self:GetAngles())
			p:SetCollisionGroup(COLLISION_GROUP_NPC)
			p:PhysicsInit(SOLID_VPHYSICS)
			p:SetOwner(self)
			p:Spawn()
			p:EmitSound("HulkZombie.Throw.FlyLoop")
			 
			local shouldvegoneforthehead = self:GetEnemy():EyePos()
			local bone = 1
			shouldvegoneforthehead = self:GetEnemy():GetBonePosition(bone)
			local vel = ((shouldvegoneforthehead - self:EyePos()) * 8):Angle()
			vel.p = vel.p
			vel = vel:Forward() * 1800 -- * (self:GetPos():Distance(self:GetEnemy():GetPos()) * 0.007)
	
			
			local phys = p:GetPhysicsObject() 
			if phys then
				p:GetPhysicsObject():AddVelocity(vel)
				p:SetPhysicsAttacker(self)
			end
			
			function p:PhysicsCollide( data, phys )
				if ( data.Speed > 90 ) then 
					if (IsValid(data.HitEntity)) then
						ParticleEffect("tank_rock_throw_impact_chunks", self:GetPos(), self:GetAngles())
						self:StopSound("HulkZombie.Throw.FlyLoop")
						self:Remove()
						self:EmitSound("HulkZombie.ThrownProjectileHit",95)
					else
						ParticleEffect("tank_rock_throw_impact_chunks", self:GetPos(), self:GetAngles())
						self:StopSound("HulkZombie.Throw.FlyLoop")
						self:Remove()
						self:EmitSound("HulkZombie.ThrownProjectileHit",95)
					end
					
				end
			end	
	elseif (event == 3001) then
		if (IsValid(self.Door)) then

			self.loco:ClearStuck() 
			--self:SetCollisionGroup( )
				if (self.Door:GetClass() != "prop_physics") then
					self:EmitSound(
						"Doors.Wood.Pound1",
						85, math.random(90,105)
					)
					debugoverlay.Text( self:GetPos(), "Breaking down door #"..self.Door:EntIndex().."!", 1.5,false )
					debugoverlay.Box( self.Door:GetPos(), self.Door:OBBMins(), self.Door:OBBMaxs(), 1.5, Color( 128, 0, 0, 128) )
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
					vel = vel:Forward() * -1800 

					
					local phys = p:GetPhysicsObject()
					if phys then
						p:GetPhysicsObject():AddVelocity(vel)
						p:SetPhysicsAttacker(self)
					end
				else
					local p = self.Door
					self:EmitSound(
						"HulkZombie.Punch",
						85, 100
					)		
					local shouldvegoneforthehead = self:GetEnemy():EyePos()
					local bone = 1
					shouldvegoneforthehead = self:GetEnemy():GetBonePosition(bone)
					local vel = ((shouldvegoneforthehead - self:EyePos()) * 8):Angle()
					vel.p = vel.p
					vel = vel:Forward() * 1800
					
					local phys = p:GetPhysicsObject()
					if phys then
						p:GetPhysicsObject():AddVelocity(vel)
						p:SetPhysicsAttacker(self)
					end
					self.Door = nil
				end
				self:SetCollisionGroup(COLLISION_GROUP_NPC)

		end
		if (IsValid(self:GetEnemy())) then
			if (self:GetEnemy():Health() > 0) then
				for k,v in ipairs(ents.FindInSphere(self:GetPos(), 150)) do
					if ((v:IsPlayer() || v:IsNPC()) and !v:IsNextBot() and v ~= self and v:GetAimVector() != nil) then 
						self.loco:ClearStuck() 
						self:EmitSound(
							"HulkZombie.Punch",
							85, 100
						)
						local dmginfo = DamageInfo()
						dmginfo:SetAttacker(self)
						dmginfo:SetInflictor(self)
						dmginfo:SetDamageType(DMG_CRUSH)
						dmginfo:SetDamage(self.AttackDamage)
						v:SetPos(v:GetPos() + Vector(0,0,30))
						v:SetVelocity(v:GetAimVector() * -1100 + Vector(0,0,100))
						if (GetConVar("skill"):GetInt() > 1) then
							dmginfo:ScaleDamage(1 + (GetConVar("skill"):GetInt() * 0.65))
						end
						v:TakeDamageInfo(dmginfo) 
						if (v:IsPlayer()) then
							v:SetViewPunchAngles(v:GetViewPunchAngles() + (Angle(120,0,0)))
						end
						v:EmitSound("PlayerZombie.AttackHit")
						timer.Simple(0.1, function()
						
							if (v:Health() < 0 and !self.PlayingSequence3 and !self.IsVersus) then
								local selanim = table.Random({"Rage_at_Knockdown_01","Rage_at_Knockdown_02","Rage_at_Knockdown_03"})
								local anim = self:LookupSequence(selanim)
								self:EmitSound("HulkZombie.Yell")
								self:PlaySequenceAndMove(anim)
								timer.Simple(self:SequenceDuration(anim) - 0.2,function()
									if (self:IsOnGround() and self.Ready and !self.PlayingSequence3) then
										if (self:GetEnemy() != nil) then
											if (string.find(self:GetModel(),"mud")) then
						
												self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
						
											else
												self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
											end
										else
											--self:SetCycle(0)
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle"))  ) )
											self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle"))  ) 
										end
									end
								end)
	
							end

						end)
					end
				end
			end
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
		if (self:Health() < 1) then
			coroutine.yield()
			return
		end 
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if self.Ready and !self.ContinueRunning then 
			
			if ( !self.ContinueRunning and self:HaveEnemy() and !GetConVar("ai_disabled"):GetBool() ) then
				-- Now that we have an enemy, the code in this block will run
				if (self:GetSequenceActivity(self:GetSequence()) == self:GetSequenceActivity(self:LookupSequence("idle"))) then
					self.PlayingSequence2 = false	
					self.PlayingSequence3 = false	
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_4")) ) 
				end
				self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self.loco:SetDesiredSpeed( 280 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self.loco:SetAcceleration(150)
				self:ChaseEnemy()
			else
				-- Since we can't find an enemy, lets wander
				-- Its the same code used in Garry's test bot
				if (self:IsOnGround()) then
					if (math.random(1,800) == 1) then
						local act = self:GetSequenceActivity(self:LookupSequence("walk"))
						self:StartActivity( act )
						self.loco:SetDesiredSpeed( 210 * 0.5 )
						self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random 
						self.Walking = true 
					else
						if (self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("walk"))) then
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) ) 
						end
						self.Walking = false
					end
				end
			end
			coroutine.wait(0.01)
		
		elseif (!self.Ready or self.ContinueRunning or self.PlayingSequence2) then

			if (self.ContinueRunning) then
				-- Now that we have an enemy, the code in this block will run
				--self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self:MoveToPos( self:GetEnemy():GetPos() ) -- Walk to a random place within about 400 units (yielding)
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
	if (self:IsOnGround() and (IsValid(self:GetEnemy()) and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0) then
		if (self.Ready and !self.PlayingSequence2 and !self.PlayingSequence3) then
			self:BodyMoveXY()
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
			if (self:GetEnemy():Health() < 1 or self:GetEnemy():IsFlagSet(FL_NOTARGET) or (self:GetEnemy():IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool())) then
				self.Enemy = nil
			end
		end
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),120)) do
			if (v:GetClass() == "entityflame" || v:GetClass() == "env_fire") then
				self:Ignite(60,120)
			end
		end
		if (self.Idling and self:GetCycle() == 1 and !self.PlayingSequence3) then
			self:SetCycle(0)
			self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle"))  ) 
		end
		if (!self:IsOnGround()) then
			if (!self.HaventLandedYet) then 
				self:SetCycle(0)
				self:ResetSequence("jump")
				self.HaventLandedYet = true
			end
		else
			if (self.HaventLandedYet) then
				self:AddGestureSequence(self:LookupSequence("Jump_Land_gesture"))
					if (self:IsOnGround()) then
						if (self:GetEnemy() != nil) then
							if (string.find(self:GetModel(),"mud")) then
	
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
	
							else
								self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
							end
						else
							self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle"))  ) )
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle"))  )
						end
					end
				self:EmitSound("HulkZombie.Thud")
				self.HaventLandedYet = false
			end
		end
		if (self.Ready and !self.PlayingSequence3 and self:GetCycle() == 0 and self:GetActivity() == -1 and !(self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_4")) && self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("mudguy_run")))) then
			self:PlayActivityAndWait( self:GetActivity() )
		elseif (self.Ready and !self.PlayingSequence3 and !self.Idling and self:GetEnemy() == nil and (self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_4")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("mudguy_run")))) then 

			local mad = self:GetSequenceActivity(self:LookupSequence("idle"))
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
					self.Door = v
				end
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
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
		self.Enemy = nil
		self:FindEnemy()
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
			if (IsValid(self.Door) and !self.ContinueRunning and self.Door:GetPos():Distance(self:GetPos()) < self.RangedAttackRange) then
				local targetheadpos,targetheadang = self.Door:GetBonePosition(1) -- Get the position/angle of the head.
				if (!self.MeleeAttackDelay2 or CurTime() > self.MeleeAttackDelay2) then
					if (self.Door:GetPos():Distance(self:GetPos()) < self.RangedAttackRange) then
						
							if (self.Door:GetClass() == "prop_door_rotating" and self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
								self.OldEnemy = self.Enemy
								self:SetEnemy(nil)
								self.WasAttackingDoor = true
								local selanim = self:LookupSequence("Hulk_RunAttack"..math.random(1,2).."_gesture")
								local anim = self:GetSequenceActivity(selanim)
								self.MeleeAttackDelay = CurTime() + 2.0
								self:AddGesture(anim)
								self.loco:ClearStuck() 
								self.DontWannaUseSameSequence = false
								self.loco:ClearStuck() 
								self:SetPlaybackRate(1)
								--self:SetCycle(0)
							else
								if (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay) then
									self:EmitSound("HulkZombie.Attack")
									self.WasAttackingDoor = true
									local selanim = self:LookupSequence("Hulk_RunAttack"..math.random(1,2).."_gesture")
									local anim = self:GetSequenceActivity(selanim)
									self.MeleeAttackDelay = CurTime() + 2.0
									self:AddGesture(anim)
									self.loco:ClearStuck() 
									self.DontWannaUseSameSequence = false
									self.loco:ClearStuck() 
									self:SetPlaybackRate(1)
									--self:SetCycle(0)
								end
							end
							
					end
				end
			end
			if (IsValid(self:GetEnemy()) and self:IsOnGround() and !self.PlayingSequence3 and !self.PlayingSequence2) then
				if (!self.PlayingSequence3 and !self.ContinueRunning and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2 and self:GetEnemy():Health() > 0) then
					local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
					if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay || CurTime() > self.MeleeAttackDelay)) then
						if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange) then
							if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then
								self:SetCollisionGroup(COLLISION_GROUP_NPC)
							end
							self:EmitSound("HulkZombie.Attack")
							local selanim = self:LookupSequence("Hulk_RunAttack"..math.random(1,2).."_gesture")
							local anim = self:GetSequenceActivity(selanim)
							self.MeleeAttackDelay = CurTime() + 2.0
							self:AddGesture(anim)
							self.loco:ClearStuck() 
							self:SetPoseParameter("move_x",0)
							self:SetPoseParameter("move_y",0)
							self.DontWannaUseSameSequence = false
						end
					end
				end
				if (math.random(1,100) == 1 and !self.PlayingSequence3 and !self.ContinueRunning and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.RangedAttackRange and self:GetEnemy():Health() > 0) then
					local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
					if (IsValid(self:GetEnemy()) and (!self.RangeAttackDelay || CurTime() > self.RangeAttackDelay) and !self.PlayingSequence3) then
						if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.RangedAttackRange and !self.PlayingSequence3) then
							self:EmitSound("HulkZombie.Throw.Pickup")
							local anim = self:SelectRandomSequence(self:GetSequenceActivity(self:LookupSequence("Throw_02")))
							self.RangeAttackDelay = CurTime() + 6.0
							self:PlaySequenceAndMove(anim)
							self.loco:ClearStuck() 
							self:SetPoseParameter("move_x",0)
							self:SetPoseParameter("move_y",0)
							self.DontWannaUseSameSequence = false
											
							timer.Simple(0.5, function()
								local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
								animent2:SetModel("models/props_debris/concrete_chunk01a.mdl") 
								animent2:SetPos(self:GetAttachment(self:LookupAttachment("debris")).Pos)
								animent2:SetAngles(self:GetAttachment(self:LookupAttachment("debris")).Ang)
								animent2:Spawn()
								animent2:Activate()
								animent2:SetParent(self)
								animent2:SetName("DebrisModel"..self:EntIndex())
								animent2:Fire("SetParentAttachment","debris",0)
								local owner = self
								function animent2:Think()
									if (IsValid(self)) then
										self:SetPos(owner:GetAttachment(owner:LookupAttachment("debris")).Pos)
										self:SetAngles(owner:GetAttachment(owner:LookupAttachment("debris")).Ang)
									end
									self:NextThink(CurTime())
									return true
								end
							end)
							timer.Simple(self:SequenceDuration(anim) - 0.2,function()	
								for k,v in ipairs(ents.FindByName("DebrisModel"..self:EntIndex())) do
									v:Remove()
								end
								if (self:IsOnGround() and self.Ready) then
									if (self:GetEnemy() != nil) then
										if (string.find(self:GetModel(),"mud")) then
					
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
					
										else
											self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
										end
									else
										--self:SetCycle(0)
										self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle"))  ) )
										self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle"))  ) 
									end
								end
							end)
						end
					end
				end
				if (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0 or self.PlayingSequence and !self.ContinueRunning) then
					self.loco:SetDesiredSpeed( 0 )
					self.loco:SetAcceleration(-270)
				elseif (!self.ContinueRunning and self:IsOnGround() and (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0 and !self.PlayingSequence3 and !self.PlayingSequence2) then
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then
						if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay || CurTime() > self.MeleeAttackDelay)) then
							if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange2) then
								self:SetCollisionGroup(COLLISION_GROUP_NPC)
							end
							self:EmitSound("HulkZombie.Attack")
							local selanim = self:LookupSequence("Hulk_RunAttack"..math.random(1,2).."_gesture")
							local anim = self:GetSequenceActivity(selanim)
							self.MeleeAttackDelay = CurTime() + 2.0
							self:AddGesture(anim)
							self.loco:ClearStuck() 
							self.DontWannaUseSameSequence = false
						end
					elseif (self.Ready) then
						if (GetConVar("skill"):GetInt() > 1) then
							self.loco:SetDesiredSpeed( 210 + (GetConVar("skill"):GetInt() * 35) )
							self.loco:SetAcceleration(300 + (GetConVar("skill"):GetInt() * 35))
						else
							self.loco:SetDesiredSpeed(210)
							self.loco:SetAcceleration(300)
						end
					end
				end
			elseif (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
				self:SetEnemy(nil)
			end
		end
		if (self.ContinueRunning or self.PlayingSequence2) then
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
	path:SetMinLookAheadDistance( 210 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position
	
	if ( !path:IsValid() ) then return "failed" end

	if (self:Health() > 0 and !self.HaventLandedYet and !self.EncounteredEnemy and !self.PlayingSequence and !self.PlayingSequence2) then 
			if (!self.IsVersus) then
				local mad = "rage_at_enemy_0"..table.Random({"1","2","3","4"})
				self:PlaySequenceAndMove( mad ) 
			end
			if (!self.IsVersus) then
				for k,v in ipairs(ents.FindByClass("npc_tank")) do
					v.Music:Stop()
				end
				self.Music:PlayEx(1.0,100)
				if (!self.MusicPlayed) then
					self.MusicPlayed = true
				end
				timer.Simple(self:SequenceDuration(mad), function()
						if (string.find(self:GetModel(),"mud")) then
		
							self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation
		
						else
							self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
						end
				end)
			end
			self.EncounteredEnemy = true
	end
	while ( path:IsValid() and IsValid(self:GetEnemy()) and !self.ContinueRunning and !self.PlayingSequence and !self.PlayingSequence3 and !self.PlayingSequence2 ) do
		if (!self.PlayingSequence3 and self:GetCycle() == 1 and self:GetSequence() != self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))) and !(self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_4")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("melee_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("AttackIncap_01")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("female_melee_noel02")) or self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("mudguy_run")))) then  
			if (self.loco:IsUsingLadder()) then
				self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  ) )			-- Set the animation
			else
				if (self:IsOnGround()) then
					if (string.find(self:GetModel(),"mud")) then

						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation

					else
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
					end
				end
			end
		end 
		local pos = self:GetEnemy():GetPos()
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(),180)) do -- avoid other infected
				if (v:GetClass() == "npc_tank" and v:EntIndex() != self:EntIndex()) then
					--pos = self:GetEnemy():GetPos() + (self:GetForward() + v:GetForward()*(-130)) + (v:GetRight() * -130 - self:GetRight()*(130))
					self:SetCollisionGroup(COLLISION_GROUP_NPC)
				end
			end
		end
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),120)) do
			if (v ~= self and IsValid(v) and (v.IsInfected or v:GetClass() == "npc_tank")) then
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
	if (self:Health() > 0 and (!self.PainSoundTime or CurTime() > self.PainSoundTime)) then
		self:EmitSound("HulkZombie.Pain")
		self.PainSoundTime = CurTime() + 0.7
	elseif (self:Health() > 0 and dmginfo:IsDamageType(DMG_BURN) and self:Health() > 0 and (!self.PainSoundTime2 or CurTime() > self.PainSoundTime2)) then
		self:EmitSound("HulkZombie.PainFire")
		self.PainSoundTime2 = CurTime() + 10.0
	end
	if (dmginfo:GetAttacker() != nil and (dmginfo:GetAttacker():IsPlayer() || dmginfo:GetAttacker():IsNPC())) then 
		if (self.Enemy != nil) then
			self:SetEnemy(dmginfo:GetAttacker())
		end
	end
	if ((math.random(1,50) == 1 || dmginfo:IsDamageType(DMG_BLAST)) and !self.PlayingSequence2 and !self.PlayingSequence) then
		local selanim = table.Random({"Shoved_Backward","Shoved_Forward","Shoved_Leftward","Shoved_Rightward"})
		local anim = self:LookupSequence(selanim)
		self:PlaySequenceAndMove(anim)
		timer.Stop("ShovedFinish"..self:EntIndex())
		timer.Create("ShovedFinish"..self:EntIndex(), self:SequenceDuration(anim) - 0.2, 1,function()
			if (self:IsOnGround() and self.Ready) then
				if (self:GetEnemy() != nil) then
					if (string.find(self:GetModel(),"mud")) then

						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  ) )			-- Set the animation

					else
						self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("run_4"))  ) )			-- Set the animation
					end
				else
					--self:SetCycle(0)
					self:ResetSequence( self:SelectWeightedSequence(self:GetSequenceActivity(self:LookupSequence("idle"))  ) )
					self:PlayActivityAndMove( self:GetSequenceActivity(self:LookupSequence("idle"))  ) 
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
			self:EmitSound("HulkZombie.BulletImpact")
		end
	end
	if (!dmginfo:IsDamageType(DMG_BURN)) then
		if (dmginfo:IsDamageType(DMG_BLAST)) then
			dmginfo:ScaleDamage(1.5)
		else
			dmginfo:ScaleDamage(3)
		end
	else
		dmginfo:ScaleDamage(50)
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
	if (self.WasShotInTheHead and !string.find(self:GetModel(),"ceda")) then
		self:EmitSound("HulkZombie.HeadlessCough")
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
		self:EmitSound("HulkZombie.Die")
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
		if (!dmginfo:IsDamageType(DMG_BUCKSHOT) and self:GetActivity() == self:GetSequenceActivity(self:LookupSequence("run_4"))) then
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
			timer.Stop("Dying"..self:EntIndex())
			timer.Create("Dying"..self:EntIndex(), 0.2, 0, function()
				if (IsValid(self) and !self.PlayingSequence2) then
					self:EmitSound("PlayerZombie.Die")
					self:BecomeRagdoll(dmginfo)
					if (self.Music) then
						self.Music:Stop()
					end
					timer.Simple(0.1, function()
						if (IsValid(self)) then
							self:Remove()
						end
					end)
				end	
			end)
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
list.Set( "NPC", "tank", {
	Name = "The Tank",
	Class = "npc_tank",
	Category = "Left 4 Dead 2"
})