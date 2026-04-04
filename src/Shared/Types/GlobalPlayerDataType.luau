--!strict


local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Types = Shared.Types
local ExportedPlayerStatTypesModule = require(Types.PlayerStatsType)

-- // type declarations
type PlayerStatsType = ExportedPlayerStatTypesModule.PlayerStats

type XP = number

type Inventory = {
	[string]: number
}

type Level = number

type Questsinfo = {
	ID: string,
	Completed: boolean,
	Active: boolean,
	CurrentProgress: number,
}


export type GlobalPlayerData = {
	[number]: {
		["Quests"]: {[string]: Questsinfo},
		["XP"]: XP,
		["Inventory"]: Inventory,
		["Level"]: Level,
		["Stats"]:  PlayerStatsType,
		["CompletedQuests"]: {},
	}
}

return {}
