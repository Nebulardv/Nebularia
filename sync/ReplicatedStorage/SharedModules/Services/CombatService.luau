local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _Players = game:GetService("Players")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local Types = Shared.Types

local WeaponData = require(Services.EquipService.WeaponData)
local _ExportedWeaponDataTypes = require(Types.WeaponDataTypes)
local DamageService = require(Services.DamageService)
local StateMachine = require(Services.StateMachine)
local PlayerStatService = require(Services.PlayerStatService)

local CombatService = {}

function CombatService.ProcessHit(
	OwnerID: number,
	OwnerCharacter: Model,
	OwnerRootPart: BasePart,
	TargetCharacter: Model,
	TargetHumanoid: Humanoid,
	TargetRootPart: BasePart,
	WeaponName: string,
	HitboxSize: Vector3
)
	local CurrentWeaponData = WeaponData[WeaponName]
	local MaxAttackDistance = CurrentWeaponData.MaxAttackDistanceStuds
	local WeaponHitboxSize = CurrentWeaponData.WeaponHitboxData.Size
	local WeaponDamage = CurrentWeaponData.Damage

	local OwnerStats = PlayerStatService.GetPlayerStats(OwnerID)
	local DamageMultiplier = OwnerStats.DamageMultiplier

	local AttackDamage = WeaponDamage * DamageMultiplier

	StateMachine.TransitionPlayerState(OwnerID, "Attacking")

	if not TargetHumanoid or not TargetRootPart then
		print("Target Humanoid or RootPart is missing")
		return
	end
	if not OwnerCharacter or not OwnerRootPart then
		print("Owner Character or RootPart is missing")
		return
	end

	if (OwnerRootPart.Position - TargetRootPart.Position).Magnitude > MaxAttackDistance then
		print("Invalid Attack, Distance between Players is too far")
		return
	end
	--[[if not StateMachine.IsInState(OwnerID, "Attacking") then
		print("Player isnt in Attacking State, Invalid Attack")
		return
	end]]

	if HitboxSize ~= WeaponHitboxSize then
		print(
			"Invalid Attack, Hitbox Size does Not match the predefined valid hitbox size for: "
				.. CurrentWeaponData.WeaponName
		)
		return
	end

	DamageService.DealDamage(TargetCharacter, TargetHumanoid, AttackDamage)
end

return CombatService
