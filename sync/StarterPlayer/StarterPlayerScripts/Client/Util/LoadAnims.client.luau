local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local Animations = Assets.Animations

local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local AnimationService = require(Services.AnimationService)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()


const function LoadAnims(Character: Model)
	for _, Animation: Animation in Animations:GetDescendants() do
		if Animation:IsA("Animation")  then
			AnimationService.LoadAnimation(
				Character,
				Animation.AnimationId,
				Animation.Name
			)
		end
	end
end

if Character then
	LoadAnims(Character)
end


Player.CharacterAdded:Connect(function(Character: Model)
	LoadAnims(Character)
end)


Player.CharacterRemoving:Connect(function(Character: Model)
	AnimationService.ClearCacheOnRemoval(Player)
end)
