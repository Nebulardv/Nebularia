const RunService = game:GetService("RunService")
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")

const Shared = ReplicatedStorage.SharedModules
const Data = Shared.Data

local GlobalPlayerData = require(Data.GlobalPlayerData)

if not RunService:IsServer() then
	error("Attempt to call Module On Client")
end

local PlayerLoaded: { [number]: boolean } = {}
local HasLeaderstats: { [number]: boolean } = {}

local InitializeLeaderstats = {}

function InitializeLeaderstats.Create(Player: Player)
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

	const PLAYER_XP_SNAPSHOT = GlobalPlayerData[Player.UserId].XP
	const PLAYER_LEVEL_SNAPSHOT = GlobalPlayerData[Player.UserId].Level

	local XP = Instance.new("IntValue")
	local Level = Instance.new("IntValue")
	local Coins = Instance.new("IntValue")

	XP.Name = "XP"
	Level.Name = "Level"
	Coins.Name = "Coins"

	XP.Parent = leaderstats
	Level.Parent = leaderstats
	Coins.Parent = leaderstats

	XP.Value = PLAYER_XP_SNAPSHOT
	Level.Value = PLAYER_LEVEL_SNAPSHOT

	warn("Created Leaderstats for Player" .. Player.UserId .. ", Created XP, Coins, And Level")
end

function InitializeLeaderstats.Init()
	Players.PlayerAdded:Connect(function(Player: Player)
		InitializeLeaderstats.Create(Player)
	end)
	for _, Player in Players:GetPlayers() do
		task.spawn(InitializeLeaderstats.Create, Player)
	end
end

return InitializeLeaderstats
