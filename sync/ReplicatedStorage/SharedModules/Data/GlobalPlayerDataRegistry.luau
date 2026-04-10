--!nonstrict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local _Types = SharedModules.Types

local Data = SharedModules.Data

local GlobalPlayerDataTable = require(Data.GlobalPlayerData)

local GlobalPlayerDataRegistry = {}

function GlobalPlayerDataRegistry.RegisterPlayerData(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	GlobalPlayerDataTable[PlayerID] = {
		["Quests"] = {},
		["XP"] = 0,
		["Inventory"] = {},
		["Level"] = 0,
		["Stats"] = {},
		["CompletedQuests"] = {},
	}
	warn("Registered Data for: " .. PlayerID)
end

function GlobalPlayerDataRegistry.Init(Player: Player?)
	if Player then
		GlobalPlayerDataRegistry.RegisterPlayerData(Player.UserId)
	else
		error("No Player Argument passed In the Init function for ModuleScript: " .. script.Name)
	end
end

return GlobalPlayerDataRegistry
