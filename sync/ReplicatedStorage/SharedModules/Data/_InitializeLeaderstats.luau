local RunService = game:GetService("RunService")

if not RunService:IsServer() then
	warn("Attempt to call Module On Client")
	return
end

local Players = game:GetService("Players")

local PlayerLoaded: { [number]: boolean } = {}
local HasLeaderstats: { [number]: boolean } = {}

Players.PlayerAdded:Connect(function(Player: Player)
	PlayerLoaded[Player.UserId] = true

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = Player

	if Player:FindFirstChild("leaderstats") then
		HasLeaderstats[Player.UserId] = true
	end

	-- // Creating XP, LEVEL, AND COINS
	if not HasLeaderstats[Player.UserId] then
		warn("Player Does not have leaderstats")
		return
	end

	local XP = Instance.new("IntValue")
	local Level = Instance.new("IntValue")
	local Coins = Instance.new("IntValue")

	XP.Name = "XP"
	Level.Name = "Level"
	Coins.Name = "Coins"

	XP.Parent = leaderstats
	Level.Parent = leaderstats
	Coins.Parent = leaderstats

	warn("Created Leaderstats for Player" .. Player.UserId .. ", Created XP, Coins, And Level")
end)
