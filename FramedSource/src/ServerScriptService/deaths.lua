local module = {}

local this = module

module.punish = function(player)
	player.PoliceTarget.Value = true
	game.Workspace.Events.HurtKarma:Fire(player)
	game.Workspace.Events.PoliceTarget:FireAllClients(player)
	game.Workspace.Events.Notify:FireClient(player, "badKill")
end

module.isPunished = function(player)
	return player.PoliceTarget.Value
end

module.reward = function(player)
	game.Workspace.Events.Reward:Fire(player)
	game.Workspace.Events.HelpKarma:Fire(player)
	player.Character.Humanoid.Health = math.min(player.Character.Humanoid.Health + 60, 100)
end

module.getTarget = function(player)
	return game.Workspace.Events.GetTarget:Invoke(player)
end

module.getHunter = function(player)
	return game.Workspace.Events.GetHunter:Invoke(player)
end

module.isRedHanded = function(player)
	return player.RedHanded.Value or player.PoliceTarget.Value or game.Workspace.Values.Epilogue.Value
end

--On The Run

module.OPoliceHitOFramed = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	game.Workspace.Events.DiedEvent:Fire(shot, hit)
	this.reward(shot)
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(5000)
end

module.OPoliceHitOPolice = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
end

--City Chase

module.CFramedHitCPolice = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.CPoliceHitCFramed = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.CPoliceHitCPolice = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
end

module.CFramedHitCFramed = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
end

--Hunted Man

module.HFramedHitHMan = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.HManHitHFramed = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.HManHitHMan = function(shot, hit, damage)
	return
end

module.HFramedHitHFramed = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
end

--Double Agents

module.DFramedHitDAgent = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
		game.Workspace.Events.Notify:FireClient(shot, 'killedAgent')
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.DAgentHitDFramed = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
		game.Workspace.Events.Notify:FireClient(shot, 'killedFramed')
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.DAgentHitDAgent = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
end

module.DFramedHitDFramed = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		shot.Character.Humanoid:TakeDamage(9999)
		return
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

--Framed

module.FramedHitFramed = function(shot, hit, damage)
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 then
		if not (this.getTarget(shot) == hit or this.getHunter(shot) == hit) then
			if this.isPunished(shot) then
				game.Workspace.Events.HurtKarma:Fire(shot)
				shot.Character.Humanoid:TakeDamage(9999)
				return
			else
				game.Workspace.Events.DiedEvent:Fire(shot, hit)
				this.punish(shot)
			end
		else
			game.Workspace.Events.DiedEvent:Fire(shot, hit)
			this.reward(shot)
		end
	end
	game.Workspace.Events.LocalShot:FireClient(shot)
	hum:TakeDamage(damage)
end

module.PoliceHitFramed = function(shot, hit, damage)
	if hit.Character.Humanoid.Health - damage <= 0 and this.isRedHanded(hit) then
		this.reward(shot)
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		game.Workspace.Events.Notify:FireClient(shot, 'policeKill')
	end	
	if this.isRedHanded(hit) then
		hit.Character.Humanoid:TakeDamage(damage)
		game.Workspace.Events.LocalShot:FireClient(shot)
	else
		game.Workspace.Events.LocalShot:FireClient(shot, true)
	end
end

module.UndercoverHitFramed = function(shot, hit, damage)
	if hit.Character.Humanoid.Health - damage <= 0 and this.isRedHanded(hit) then
		this.reward(shot)
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		game.Workspace.Events.Notify:FireClient(shot, 'policeKill')
	end
	if this.isRedHanded(hit) then
		hit.Character.Humanoid:TakeDamage(damage)
		game.Workspace.Events.LocalShot:FireClient(shot)
	end
end

module.UndercoverHitUndercover = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, false)
end

module.PoliceHitUndercover = function(shot, hit, damage)
	damage = damage / 5
	local hum = hit.Character.Humanoid
	if hum.Health - damage <= 0 and this.isRedHanded(hit) then
		game.Workspace.Events.HurtKarma:Fire(shot)
		shot.Character.Humanoid:TakeDamage(9999)
		hum:TakeDamage(damage)
		game.Workspace.Events.LocalShot:FireClient(shot, true)
		return
	end
	if this.isRedHanded(hit) then
		hum:TakeDamage(damage)
		game.Workspace.Events.LocalShot:FireClient(shot, true)
	end
end

module.UndercoverHitPolice = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
	--pass
end

module.FramedHitPolice = function(shot, hit, damage)
	game.Workspace.Events.LocalShot:FireClient(shot, true)
	if game.Workspace.Values.Epilogue.Value then
		if hit.Character.Humanoid.Health - damage <= 0 then
			game.Workspace.Events.DiedEvent:Fire(shot, hit)
		end
		hit.Character.Humanoid:TakeDamage(damage)
		game.Workspace.Events.LocalShot:FireClient(shot)
	end
end

module.FramedHitUndercover = function(shot, hit, damage)
	if hit.Character.Humanoid.Health - damage <= 0 then
		game.Workspace.Events.DiedEvent:Fire(shot, hit)
		this.reward(shot)
		game.Workspace.Events.Notify:FireClient(shot, 'undercover')
	end
	local hum = hit.Character.Humanoid
	hum:TakeDamage(damage)
	game.Workspace.Events.LocalShot:FireClient(shot)
end

return module
