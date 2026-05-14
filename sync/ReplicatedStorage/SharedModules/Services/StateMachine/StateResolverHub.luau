const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Shared = ReplicatedStorage.SharedModules
const Services = Shared.Services

const StateMachine = Services.StateMachine
const StateResolver = require(Services.StateMachine.StateResolver)
const PlayerStateConditions = require(Services.StateMachine.PlayerStateConditions)
const StateController = require(StateMachine.StateController)

const Events = ReplicatedStorage.Events
const Signals = Events.Signals
const OnStateChangedBindable: BindableEvent = Signals.OnStateChangedBindable

const Players = game:GetService("Players")
const SendInputStateCondition: RemoteEvent = Signals.SendInputStateCondition

local StateResolverHub = {}
local Initialized = false

const function InitAdded(player: Player)
	PlayerStateConditions.RegisterPlayerConditions(player)

	OnStateChangedBindable.Event:Connect(function(NewPlayerState)
		StateController.ApplyState(player, NewPlayerState)
	end)
end

function StateResolverHub.Init()
	if Initialized then
		return
	end
	Initialized = true

	SendInputStateCondition.OnServerEvent:Connect(function(Player: Player, StateConditions)
		PlayerStateConditions.UpdateConditions(Player, StateConditions)

		local CurrentConditions = PlayerStateConditions.GetConditions(Player)
		StateResolver.ResolveState(CurrentConditions, Player)
	end)

	for _, Player in Players:GetPlayers() do
		task.spawn(InitAdded, Player)
	end

	Players.PlayerAdded:Connect(InitAdded)
end

return StateResolverHub
