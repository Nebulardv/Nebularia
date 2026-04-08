local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local Events = ReplicatedStorage.Events
local Signals = Events.Signals

local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local StateMachine = require(Services.StateMachine)

type StateConditions = {
	IsSprinting: boolean?,
	IsMoving: boolean?,
	IsBlocking: boolean?,
	IsAttacking: boolean?,
	IsStunned: boolean?,
	IsDead: boolean?,
}

local StateResolver = {}

function StateResolver.ResolveState(CurrentConditions: StateConditions, Player: Player)
	if CurrentConditions.IsAttacking then
		StateMachine.TransitionPlayerState(Player.UserId, "Attacking")
		return
	end
	if CurrentConditions.IsBlocking then
		StateMachine.TransitionPlayerState(Player.UserId, "Blocking")
		return
	end
	
	if CurrentConditions.IsStunned then
		StateMachine.TransitionPlayerState(Player.UserId, "Stunned")
		return
	end
	if CurrentConditions.IsSprinting then
		StateMachine.TransitionPlayerState(Player.UserId, "Sprinting")
		return
	end
	
	if CurrentConditions.IsMoving then
		StateMachine.TransitionPlayerState(Player.UserId, "Walking")
		return
	end
	
	if CurrentConditions.IsDead then
		StateMachine.TransitionPlayerState(Player.UserId, "Dead")
		return
	end
	
	StateMachine.TransitionPlayerState(Player.UserId, "Idle")
end

return StateResolver