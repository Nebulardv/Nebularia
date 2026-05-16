local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services

local PlayerStatService
local StateMachine

local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local OnStateChangedRemote: RemoteEvent = Signals.OnStateChangedRemote
local OnStateChangedBindable: BindableEvent = Signals.OnStateChangedBindable
local OnPlayerStatModifiedBindable: BindableEvent = Signals.OnPlayerStatModifiedBindable
local OnPlayerStatModifiedRemote: RemoteEvent = Signals.OnPlayerStatModifiedRemote
local SendStatTableData: RemoteEvent = Signals.SendStatTableData
local SendStatesData: RemoteEvent = Signals.SendStatesData


local ConnectedPlayers = {}

const function SignalListen(Player: Player)
	if ConnectedPlayers[Player.UserId] then return end
	ConnectedPlayers[Player.UserId] = true

	OnPlayerStatModifiedBindable.Event:Connect(function(StatName: string, Value: number)
		OnPlayerStatModifiedRemote:FireClient(Player, StatName, Value)
	end)

	OnStateChangedBindable.Event:Connect(function(NewState: string)
		OnStateChangedRemote:FireClient(Player, NewState)
	end)
end

const function SyncDataToClient(Player: Player)
	local PlayerStats = PlayerStatService.GetPlayerStats(Player.UserId)
	if not PlayerStats then
		warn("PLAYER STATS NOT FOUND YET FOR " .. Player.Name .. " - RETRYING...")
		return
	end

	local PlayerState = StateMachine.GetCurrentPlayerState(Player.UserId)
	SendStatTableData:FireClient(Player, PlayerStats)
	SendStatesData:FireClient(Player, PlayerState)
end

local ReplicatorServer = {}

function ReplicatorServer.Init(Player: Player)
	PlayerStatService = require(Services.PlayerStatService)
	StateMachine = require(Services.StateMachine)

	
	if Player.Character then
		SyncDataToClient(Player)
		SignalListen(Player)
	end

	Player.CharacterAdded:Connect(function()
		SyncDataToClient(Player)
		SignalListen(Player)
	end)
end


Players.PlayerRemoving:Connect(function(Player)
	ConnectedPlayers[Player.UserId] = nil
end)

return ReplicatorServer
