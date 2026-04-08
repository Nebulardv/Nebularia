local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local Shared = ReplicatedStorage.SharedModules
local Types = Shared.Types
local Data = Shared.Data

local Replicator = require(Data.ClientReplicatedData)

if not Replicator then
	print("Replicator Is Not a child of: " .. script.Name)
end

local PlayerStatTypesModule = require(Types.PlayerStatsType)

type PlayerStatsType = PlayerStatTypesModule.PlayerStats

local OnStateChangedRemote: RemoteEvent = Signals.OnStateChangedRemote
local OnPlayerStatModifiedRemote: RemoteEvent = Signals.OnPlayerStatModifiedRemote

local SendStatTableData = Signals.SendStatTableData
local SendStatesData = Signals.SendStatesData

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local PlayerId = Player.UserId

SendStatesData.OnClientEvent:Connect(function(PlayerState: string)
	if not Replicator.PlayerStates[PlayerId] then
		Replicator.PlayerStates[PlayerId] = {}
	end

	if not Replicator.PlayerStates[PlayerId].State then
		Replicator.PlayerStates[PlayerId].State = PlayerState
	end

	Replicator.PlayerStates[PlayerId].State = PlayerState
	print("Spawning In with State: " .. Replicator.PlayerStates[PlayerId].State)
end)

OnStateChangedRemote.OnClientEvent:Connect(function(NewState: string)
	if not Replicator.PlayerStates[PlayerId] then
		Replicator.PlayerStates[PlayerId] = {}
	end
	if not Replicator.PlayerStates[PlayerId].State then
		Replicator.PlayerStates[PlayerId].State = NewState
	end

	Replicator.PlayerStates[PlayerId].State = NewState
	--print("New State Is: ".. Replicator.PlayerStates[PlayerId].State)
end)

OnPlayerStatModifiedRemote.OnClientEvent:Connect(function(StatName, Amount)
	Replicator.PlayerStats[PlayerId][StatName] = Amount
end)

SendStatTableData.OnClientEvent:Connect(function(PlayerStats: PlayerStatsType)
	if not Replicator.PlayerStats[PlayerId] then
		Replicator.PlayerStats[PlayerId] = {}
	end

	Replicator.PlayerStats[PlayerId] = PlayerStats
end)
