--!strict
const Players = game:GetService("Players")
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const SharedModules = ReplicatedStorage.SharedModules
local _Types = SharedModules.Types

const Data = SharedModules.Data
const Packages = SharedModules.Packages
const DataService = require(Packages.DataService).server


local GlobalPlayerDataTable = require(Data.GlobalPlayerData)

local GlobalPlayerDataRegistry = {}

function GlobalPlayerDataRegistry.RegisterPlayerData(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	local Player = Players:GetPlayerByUserId(PlayerID)
	DataService:waitForData(Player)

	local Profile = DataService:getProfile(Player)
	local ProfileData = Profile.Data
	
	--print(ProfileData)

	GlobalPlayerDataTable[PlayerID] = ProfileData -- This is the new Defined Dictionary, which maps to the template
	--[[GlobalPlayerDataTable[PlayerID] = {
		["Quests"] = {},
		["XP"] = 0,
		["Inventory"] = {},
		["Level"] = 0,
		["Stats"] = {},
		["CompletedQuests"] = {},
	}]] -- Old Data Dictionary
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
