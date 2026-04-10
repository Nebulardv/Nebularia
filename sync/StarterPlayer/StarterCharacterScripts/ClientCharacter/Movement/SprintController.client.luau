local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Players = game:GetService("Players")
local Shared = ReplicatedStorage.SharedModules
local Utils = Shared.Utilities
local Services = Shared.Services
local AnimationService = require(Services.AnimationService)
local EffectsService = require(Services.EffectsService)

local Assets = ReplicatedStorage.Assets
local Animations = Assets.Animations
local SprintAnimation: Animation = Animations.Movement.SprintAnimation

local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart: BasePart = Character:WaitForChild("HumanoidRootPart")
local CurrentCamera = workspace.CurrentCamera

local SendSignals = require(Utils.SendSignals)

local Keys = {
	["Sprint"] = Enum.KeyCode.LeftShift,
}
local FOVChange = 90
local DefaultFOV = 70
local ZoomTime = 0.5

local IsMoving: boolean = false
local _IsSprinting: boolean = false

local RunningSound: Sound = HumanoidRootPart:WaitForChild("Running") :: Sound

local SprintSoundPlayBackSpeed = 2
local WalkingSoundPlayBackSpeed = 1.25

UserInputService.InputBegan:Connect(function(InputObj: InputObject, GameProcessed: boolean)
	if GameProcessed then
		return
	end
	local SprintKey = Keys.Sprint

	if InputObj.KeyCode == SprintKey then
		if Humanoid.MoveDirection.Magnitude <= 0 then
			return
		end

		SendSignals.SendInputStatesCondition({ IsSprinting = true })

		local _AnimationTrack: AnimationTrack =
			AnimationService.PlayAnimation(Character, SprintAnimation.Name, "Yes", 0.2)

		TweenService:Create(
			CurrentCamera,
			TweenInfo.new(ZoomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			{ FieldOfView = FOVChange }
		):Play()
		EffectsService.MutateSoundProperty(RunningSound, { "PlaybackSpeed" }, SprintSoundPlayBackSpeed)
	end
end)

UserInputService.InputEnded:Connect(function(Input: InputObject, GameProcessed: boolean)
	if GameProcessed then
		return
	end
	local SprintKey = Keys.Sprint

	if Input.KeyCode == SprintKey then
		local Stamina = Player:GetAttribute("Stamina") or 100
		if Stamina <= 0 then
			AnimationService.StopAnimation(Character, SprintAnimation.Name, "Yes", 0.2)
			return
		end

		SendSignals.SendInputStatesCondition({ IsSprinting = false })
		AnimationService.StopAnimation(Character, SprintAnimation.Name, "Yes", 0.2)
		TweenService:Create(
			CurrentCamera,
			TweenInfo.new(ZoomTime, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
			{ FieldOfView = DefaultFOV }
		):Play()

		EffectsService.MutateSoundProperty(RunningSound, { "PlaybackSpeed" }, WalkingSoundPlayBackSpeed)
	end
end)

Humanoid.Running:Connect(function(Speed: number)
	local CurrentIsMoving: boolean = Speed > 0.1

	if CurrentIsMoving ~= IsMoving then
		IsMoving = CurrentIsMoving
		SendSignals.SendInputStatesCondition({ IsMoving = IsMoving })
	end
end)
