local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local Weapons = Assets.Weapons

local SharedModules = ReplicatedStorage.SharedModules
local Types = SharedModules.Types

local ChestsTypeModule = require(Types.ChestsType)

type ChestsType = ChestsTypeModule.Chests

local Chests: ChestsType = {
	["Common Chest"] = {
		Items = {},
	},
	["Uncommon Chest"] = {
		Items = {
			["Katana"] = Weapons.Katana,
		},
		Data = {
			OpenTime = 1,
			OpenPositionOffset = -3,
			ItemPositionOffset = -1,
			ItemRotationOffsetCFrame = CFrame.Angles(math.rad(90), 0, math.rad(90)),
		},
	},
	["Rare Chest"] = {
		Items = {},
	},
	["Epic Chest"] = {
		Items = {},
	},
	["Legendary Chest"] = {
		Items = {},
	},
}

return Chests
