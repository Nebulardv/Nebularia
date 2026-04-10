local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local TypesFolder = Shared.Types
local Events = ReplicatedStorage.Events
local Signals = Events.Signals

local OnStateChangedBindable: BindableEvent = Signals.OnStateChangedBindable

local StateMachineTransitionsType = require(TypesFolder.StateMachineTransitions)
local StatesType = require(TypesFolder.States)

type States = StatesType.States

type PlayerStatesType = { [number]: { [string]: any } }

local StateMachineTransitionsTable: StateMachineTransitionsType.StateMachineTransitions = {
	["Idle"] = {
		["Attacking"] = true,
		["Blocking"] = true,
		["Stunned"] = true,
		["Dead"] = true,
		["Sprinting"] = true,
		["Walking"] = true,
	},
	["Attacking"] = {
		["Idle"] = true,
		["Blocking"] = true,
		["Stunned"] = true,
		["Dead"] = true,
		["Sprinting"] = true,
		["Walking"] = true,
	},
	["Blocking"] = {
		["Idle"] = true,
		["Stunned"] = true,
		["Dead"] = true,
		["Sprinting"] = true,
		["Walking"] = true,
	},
	["Stunned"] = {
		["Attacking"] = true,
		["Blocking"] = true,
		["Dead"] = true,
		["Sprinting"] = true,
		["Walking"] = true,
	},
	["Sprinting"] = {
		["Idle"] = true,
		["Blocking"] = true,
		["Stunned"] = true,
		["Dead"] = true,
		["Attacking"] = true,
		["Walking"] = true,
	},
	["Walking"] = {
		["Idle"] = true,
		["Blocking"] = true,
		["Stunned"] = true,
		["Dead"] = true,
		["Attacking"] = true,
		["Sprinting"] = true,
	},
	["Dead"] = {},
}

local PlayerStates: PlayerStatesType = {}

local StateMachine = {}

function StateMachine.RegisterPlayer(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	PlayerStates[PlayerID] = {
		State = "Idle",
	}

	warn("Set State For: " .. tostring(PlayerID) .. " Current State is: " .. PlayerStates[PlayerID].State)
end

function StateMachine.GetCurrentPlayerState(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	if not PlayerStates[PlayerID] then
		print("Player Has No States")
		return
	end
	return PlayerStates[PlayerID].State
end

function StateMachine.TransitionPlayerState(PlayerID: number, NewState: States)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	local CurrentPlayerState = StateMachine.GetCurrentPlayerState(PlayerID)
	if not CurrentPlayerState then
		print("No Player State")
		return
	end
	if PlayerStates[PlayerID].State == NewState then
		--print("Player State is already: ".. NewState)
		return
	end

	local StateTransitions = StateMachineTransitionsTable[CurrentPlayerState]
	local ValidStateTransitions = StateTransitions[NewState]
	if ValidStateTransitions ~= true then
		print("Invalid State Transition")
		return
	end

	PlayerStates[PlayerID].State = NewState
	--print("Transitioned Player's State From: ".. CurrentPlayerState.. " To: ".. NewState)
	--print("New Player State: ".. PlayerStates[PlayerID].State)

	OnStateChangedBindable:Fire(NewState)
end

function StateMachine.IsInState(PlayerID: number, State: States)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	if not PlayerStates[PlayerID] then
		print("No Player State")
		return
	end
	if not PlayerStates[PlayerID].State then
		print("No Player State")
		return
	end

	return PlayerStates[PlayerID].State == State
end

function StateMachine.ForcePlayerState(PlayerID: number, State: States)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	PlayerStates[PlayerID].State = State
end

function StateMachine.Init(Player: Player?)
	if Player then
		StateMachine.RegisterPlayer(Player.UserId)
	else
		error("No Player Argument passed In the Init function for ModuleScript: " .. script.Name)
	end
end

return StateMachine
