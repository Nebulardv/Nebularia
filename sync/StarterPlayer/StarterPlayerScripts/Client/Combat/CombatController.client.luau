local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local SharedModules = ReplicatedStorage.SharedModules
local Services = SharedModules.Services
local Events = ReplicatedStorage.Events
local _UtilsShared = SharedModules.Utilities
local Signals = Events.Signals
local RequestSignals = Events.RequestSignals

local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts
local ClientScripts = StarterPlayerScripts.Client
local _UtilsClient = ClientScripts.Util

local EquipService = Services.EquipService
local SendSignals = require(ReplicatedStorage.SharedModules.Utilities.SendSignals)
local WeaponData = require(EquipService.WeaponData)
local _StateMachine = require(Services.StateMachine)
local HitboxService = require(Services.HitboxService)
local AnimationService = require(Services.AnimationService)
local EffectsService = require(Services.EffectsService)

local Assets = ReplicatedStorage.Assets
local _VFX = Assets.VFX
local Sounds = Assets.Sounds

local SendSlashEffectsToAllClients: RemoteEvent = Signals.SendSlashEffectToAllClients

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart: BasePart = Character:WaitForChild("HumanoidRootPart")
local _Humanoid: Humanoid = Character:WaitForChild("Humanoid")

local ClientCombatState = {}

ClientCombatState[Player] = {
	ComboStep = 0,
	LastAttackTime = 0,
}

local ComboResetTime = 1.6 -- This is a static value for now, but can be made dynamic in the future if needed
local AttackKey = Enum.UserInputType.MouseButton1

local HitboxParams = OverlapParams.new()
HitboxParams.FilterType = Enum.RaycastFilterType.Exclude
HitboxParams.FilterDescendantsInstances = { Character }

local function GetEquippedWeapon(CharacterParam: Model)
	for _, Item in Character:GetChildren() do
		if Item:IsA("Tool") then
			local EquippedWeapon = CharacterParam:FindFirstChild(Item.Name)
			if not EquippedWeapon then
				return
			end
			return EquippedWeapon
		end
	end
end

local function GetHitboxData(HitboxObj, HitTargets)
	local Hits = HitboxService.GetHitboxData(HitboxObj, Player, "CharacterHit")
	for _, HitItem in Hits do
		if not HitTargets[HitItem] then
			HitTargets[HitItem] = true
			return HitItem
		end
	end
end

UserInputService.InputBegan:Connect(function(Input: InputObject, GameProcessed: boolean)
	if GameProcessed then
		return
	end

	local EquippedWeapon = GetEquippedWeapon(Character)
	if not EquippedWeapon then
		return
	end
	if Input.UserInputType == AttackKey then
		local HitTargets = {}
		local EquippedWeaponName = EquippedWeapon.Name

		local EquippedWeaponData = WeaponData[EquippedWeaponName]
		if not EquippedWeaponData then
			print("Weapon Does Not have WeaponData")
		end

		local AttackIntervalCooldownTime = EquippedWeaponData.AttackIntervalCooldown
		local _AttackCooldownTime: number = EquippedWeaponData.WeaponAttackCooldown
		local Now = os.clock()

		if Now - ClientCombatState[Player].LastAttackTime > ComboResetTime then
			ClientCombatState[Player].ComboStep = 0
		end
		if ClientCombatState[Player].ComboStep >= 4 then
			if Now - ClientCombatState[Player].LastAttackTime < ComboResetTime then
				return
			end
		end
		if Now - ClientCombatState[Player].LastAttackTime < AttackIntervalCooldownTime then
			return
		end

		ClientCombatState[Player].ComboStep += 1
		ClientCombatState[Player].LastAttackTime = Now

		local AttackAnimationKeyName = "M" .. ClientCombatState[Player].ComboStep
		local AttackAnimations = EquippedWeaponData.AttackAnims
		if not AttackAnimations then
			print("Weapon Does Not have AttackAnims")
			return
		end
		local AttackAnimation: Animation = AttackAnimations[AttackAnimationKeyName]

		if not AttackAnimation then
			print("AttackAnimation Does Not Exist")
			return
		end

		if ClientCombatState[Player].ComboStep > EquippedWeaponData.MaxCombo then
			ClientCombatState[Player].ComboStep = 1
		end
		local HitboxSize = EquippedWeaponData.WeaponHitboxData.Size
		local _HitboxLifetime = EquippedWeaponData.WeaponHitboxData.HitboxLifetime

		local WeaponSounds: Folder = Sounds[EquippedWeaponName]
		local SwingSound = WeaponSounds:WaitForChild("Swing") :: Sound
		local SwingSoundClone = SwingSound:Clone()

		AnimationService.OnMarkerReached(Character, AttackAnimation.Name, "Impact", function()
			local HitboxCFrame = HumanoidRootPart.CFrame * EquippedWeaponData.WeaponHitboxData.CFrameOffset
			local HitboxObj = HitboxService.CreateHitbox(HitboxCFrame, HitboxSize, HitboxParams)
			local TargetCharacter: Model = GetHitboxData(HitboxObj, HitTargets)
			SendSignals.RequestAttack(TargetCharacter, HitboxSize)
			--[[SendSignals.RequestStateTransition(
				"Attacking"
			)]]
			SendSlashEffectsToAllClients:FireServer()

			SendSignals.RequestStateTransition("Attacking")

			--[[HitboxService.VisualizeHitbox(
				HitboxCFrame,
				HitboxSize,
				0.2
			)]]

			EffectsService.PlaySoundEffects(SwingSoundClone, Character)
		end)

		local _AnimTrack: AnimationTrack = AnimationService.PlayAnimation(Character, AttackAnimation.Name)
	end
end)

UserInputService.InputEnded:Connect(function(Input: InputObject, Gpe: boolean)
	if Gpe then
		return
	end
	if Input.KeyCode == AttackKey then
		Signals.SendInputStatesCondition({ IsAttacking = false })
	end
end)
