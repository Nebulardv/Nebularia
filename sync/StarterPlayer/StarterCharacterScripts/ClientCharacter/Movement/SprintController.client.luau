const UserInputService = game:GetService("UserInputService")
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const TweenService = game:GetService("TweenService")
const Players = game:GetService("Players")

const Shared = ReplicatedStorage.SharedModules
const Controllers_Components = Shared["Controllers/Components"]
const Data = Shared.Data


const Utils = Shared.Utilities
const Services = Shared.Services
local _ClientReplicatedData = require(ReplicatedStorage.SharedModules.Data.ClientReplicatedData)
const AnimationService = require(Services.AnimationService)
const EffectsService = require(Services.EffectsService)
const MovementController = Controllers_Components.MovementController
const StaminaController = require(MovementController.StaminaController)

const _ClientReplicatedData = require(Data.ClientReplicatedData)

const Assets = ReplicatedStorage.Assets
const Animations = Assets.Animations
local SprintAnimation: Animation = Animations.Movement.SprintAnimation

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart: BasePart = Character:WaitForChild("HumanoidRootPart")
local CurrentCamera = workspace.CurrentCamera

const SendSignals = require(Utils.SendSignals)

const Keys = {
	["Sprint"] = Enum.KeyCode.LeftShift,
}

local FOVChange = 90
local DefaultFOV = 70
local ZoomTime = 0.6

local IsMoving: boolean = false

local RunningSound: Sound = HumanoidRootPart:WaitForChild("Running") :: Sound

local SprintSoundPlayBackSpeed = 2
local WalkingSoundPlayBackSpeed = 1.25

UserInputService.InputBegan:Connect(function(InputObj: InputObject, GameProcessed: boolean)
	if GameProcessed then
		return
	end
	local SprintKey = Keys.Sprint

	if UserInputService:IsKeyDown(SprintKey) --[[InputObj.KeyCode == SprintKey]] then
		if Humanoid.MoveDirection.Magnitude <= 0 then
			return
		end
		if  Player:GetAttribute("Stamina") <= 0 then
			print("NO STAMINA LEFT")
			return
		end
		
		SendSignals.SendInputStatesCondition({ IsSprinting = true })

		local _AnimationTrack: AnimationTrack =
			AnimationService.PlayAnimation(Character, SprintAnimation.Name, "Yes", 0.5)

		TweenService:Create(
			CurrentCamera,
			TweenInfo.new(ZoomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ FieldOfView = FOVChange }
		):Play()
		EffectsService.MutateSoundProperty(RunningSound, { "PlaybackSpeed" }, SprintSoundPlayBackSpeed)
		StaminaController.DecreaseSprintStamina(Player)
	end
end)

UserInputService.InputEnded:Connect(function(Input: InputObject, GameProcessed: boolean)
	if GameProcessed then
		return
	end
	local SprintKey = Keys.Sprint

	if  Input.KeyCode == SprintKey then
		SendSignals.SendInputStatesCondition({ IsSprinting = false })
		AnimationService.StopAnimation(Character, SprintAnimation.Name, "Yes", 0.5)
		TweenService:Create(
			CurrentCamera,
			TweenInfo.new(ZoomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
			{ FieldOfView = DefaultFOV }
		):Play()

		EffectsService.MutateSoundProperty(RunningSound, { "PlaybackSpeed" }, WalkingSoundPlayBackSpeed)

		StaminaController.StopStaminaDecrease()
	end
end)

Humanoid.Running:Connect(function(Speed: number)
	local CurrentIsMoving: boolean = Speed > 0.1

	if CurrentIsMoving ~= IsMoving then
		IsMoving = CurrentIsMoving
		SendSignals.SendInputStatesCondition({ IsMoving = IsMoving })
	end
end)