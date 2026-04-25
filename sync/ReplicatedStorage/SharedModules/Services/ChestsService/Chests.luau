local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Assets = ReplicatedStorage.Assets
local Weapons = Assets.Weapons

local SharedModules = ReplicatedStorage.SharedModules
local Types = SharedModules.Types

local ChestsTypeModule = require(Types.ChestsType)

type ChestsType = ChestsTypeModule.Chests

local Chests: ChestsType = {
	["Common Chest"] = {
		Items = {},
		OpenCallback = function() end,
	},
	["Uncommon Chest"] = {
		Items = {
			["Katana"] = Weapons.Katana,
		},
		OpenCallback = function(Chest: Model)
			local _OpenTween = TweenService:Create(
				Chest.PrimaryPart :: BasePart | UnionOperation,
				TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				{ CFrame = (Chest.PrimaryPart :: BasePart | UnionOperation).CFrame * CFrame.new(-5, 0, 0) }
			):Play()
		end,
	},
	["Rare Chest"] = {
		Items = {},
		OpenCallback = function() end,
	},
	["Epic Chest"] = {
		Items = {},
		OpenCallback = function() end,
	},
	["Legendary Chest"] = {
		Items = {},
		OpenCallback = function() end,
	},
}

return Chests

--[[// The reason for creating callback / functions for each chest open is because I will have differebnt
chest models that will need different scripting and etcetera
]]
