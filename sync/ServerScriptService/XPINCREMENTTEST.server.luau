--[[local Players = game:GetService("Players")

const function Increment(Plr)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local SharedModules = ReplicatedStorage.SharedModules
	local Services = SharedModules.Services
	local XPService = require(Services.XPService)

	if XPService then
		print("XPSERVICE FOUND")
	end

	while true do
		task.wait(2)
		XPService.IncreaseXP(1000, Plr.UserId)
	end
end

Players.PlayerAdded:Connect(function(Plr: Player)
	task.wait(8)
	print("WaitFinished")
	Increment(Plr)
end)]]
