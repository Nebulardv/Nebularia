--[[
	By @nebulardv[socials], @strb575[roblox]
	
	Simple module to simplify singal firing to the server.	
	
	Signals denoted via variables
	Module functions simplify sending signals to server where server does
	Validation and the action
	
	Example Usage: 
	SendSignals.RequestInventoryUpdateSignal("Sword", 1, "AddItem")
	
	Server or RecievedSignals Module:
	On Signal Event, Validates RequestedItemName and Amount, then
	Does action on player's inventory

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local TypesFolder = SharedModules.Types
local WeaponDataTypes = require(TypesFolder.WeaponDataTypes)

type WeaponDataTableType = WeaponDataTypes.WeaponData
type AvailableStates = "Idle" | "Attacking" | "Dead" | "Stunned" | "Blocking" | "Sprinting" | "Walking"
type Modifiers = "+" | "-" | "*" | "/" | "^"
--type RequestedActions = "AddItem"? | "RemoveItem"? | "ClearInventory"?
type InputStateConditions = {
	IsSprinting: boolean?,
	IsMoving: boolean?,
	IsBlocking: boolean?,
	IsAttacking: boolean?,
}

local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local RequestSignals = Events.RequestSignals
local RequestInventoryUpdateSignal: RemoteEvent = RequestSignals.RequestUpdateInventory
local RequestWeaponHandlerSignal: RemoteEvent = RequestSignals.RequestWeaponHandler
local RequestStateTransitionSignal: RemoteEvent = RequestSignals.RequestStateTransition
local RequestStatModification: RemoteEvent = RequestSignals.RequestStatModification
local RequestAttackSignal: RemoteEvent = RequestSignals.RequestAttack

local SendEffectsToAllClients: RemoteEvent = Signals.SendEffectsToAllClients
local SendSoundEffectsToAllClients: RemoteEvent = Signals.SendSoundEffectsToAllClients
local SendInputStateCondition: RemoteEvent = Signals.SendInputStateCondition

local SendSignals = {}

function SendSignals.RequestInventoryUpdateSignal(
	InventoryUpdateRequestData: {
		RequestedItemName: string,
		Amount: number,
		RequestedAction: string, --RequestedActions,
	}
)
	if not RequestInventoryUpdateSignal then
		print(tostring(RequestInventoryUpdateSignal) .. " Not Found")
		return
	end

	RequestInventoryUpdateSignal:FireServer(InventoryUpdateRequestData)
end

function SendSignals.RequestWeaponHandlerSignal(RequestedAction: "Equip" | "Unequip")
	if not RequestWeaponHandlerSignal then
		print(tostring(RequestWeaponHandlerSignal) .. " Not Found")
		return
	end
	RequestWeaponHandlerSignal:FireServer(RequestedAction)
end

function SendSignals.RequestStateTransition(RequestedState: AvailableStates)
	if not RequestStateTransitionSignal then
		print(tostring(RequestStateTransitionSignal) .. " Not Found")
		return
	end
	RequestStateTransitionSignal:FireServer(RequestedState)
end

function SendSignals.RequestStatModification(RequestStatModificationData: {
	StatToModify: string,
	Amount: number,
	Modifier: Modifiers,
})
	if not RequestStatModification then
		print(tostring(RequestStatModification) .. " Not Found")
		return
	end
	RequestStatModification:FireServer(RequestStatModificationData)
end

function SendSignals.RequestAttack(TargetCharacter: Model, HitboxSize: Vector3)
	if not RequestAttackSignal then
		print(tostring(RequestAttackSignal) .. " Not Found")
		return
	end
	RequestAttackSignal:FireServer(TargetCharacter, HitboxSize)
end

function SendSignals.SendEffectsToAllClients(
	EffectsParent: BasePart | Model | Part,
	EffectAttachment: Attachment,
	EffectsPosition: CFrame | Vector3,
	EmitCount: number
)
	if not EffectsParent then
		print("EffectsParent not found")
		return
	end
	if not EffectAttachment then
		print("EffectAttachment not found")
		return
	end
	if not EffectsPosition then
		print("EffectsPosition not found")
		return
	end
	if not EmitCount then
		print("EmitCount not found")
		return
	end

	if not SendEffectsToAllClients then
		print(tostring(SendEffectsToAllClients) .. " Not Found")
		return
	end

	SendEffectsToAllClients:FireAllClients(EffectsParent, EffectAttachment, EffectsPosition, EmitCount)
end

function SendSignals.SendSoundEffectdToAllClients(SoundEffect: Sound, SoundParent: BasePart | Model | Part)
	if not SoundEffect then
		print("Sound Effect not passed in as a parameter")
		return
	end
	if not SoundParent then
		print("Sound Parent not passed in as a parameter")
		return
	end
	if not SendSoundEffectsToAllClients then
		print(tostring(SendSoundEffectsToAllClients) .. " Not Found")
		return
	end

	SendSoundEffectsToAllClients:FireAllClients(SoundEffect, SoundParent)
end

function SendSignals.SendInputStatesCondition(InputStateCondition: InputStateConditions)
	if not SendInputStateCondition then
		print(tostring(SendInputStateCondition) .. " Not Found")
		return
	end
	SendInputStateCondition:FireServer(InputStateCondition)
end

return SendSignals
