local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local Animations = Assets.Animations
local DefaultWalkNew = Animations.DefaultWalk

local Animate: LocalScript = Character:WaitForChild("Animate")
local WalkObject: StringValue = Animate.walk

if not Animate or not WalkObject then
	print("Animate or WalkObject Not found")
	return
end

local AnimationObject: Animation = WalkObject.WalkAnim

if not AnimationObject then
	print("AnimationObject Not found")
	return
end

AnimationObject.AnimationId = DefaultWalkNew.AnimationId

local Running = HumanoidRootPart:WaitForChild("Running")

Running.PlaybackSpeed = 1.25
Running.Volume = 1.5
