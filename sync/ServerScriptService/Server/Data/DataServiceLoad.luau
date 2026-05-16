const ReplicatedStorage = game:GetService("ReplicatedStorage")
const SharedModules = ReplicatedStorage:WaitForChild("SharedModules")
const Packages = SharedModules.Packages
const _Data = SharedModules.Data

local DataService = require(Packages.DataService).server

local DataServiceLoad = {}

function DataServiceLoad.Init()
	DataService:init({
		template = {
			["Quests"] = {},
			["XP"] = 0,
			["Inventory"] = {},
			["Level"] = 0,
			["Stats"] = {},
			["CompletedQuests"] = {},
		}
	})
end
return DataServiceLoad