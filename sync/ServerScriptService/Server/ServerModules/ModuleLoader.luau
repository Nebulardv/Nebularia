local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local DataModules = SharedModules.Data
local Services = SharedModules.Services

local LoadedHighestPriority = false

type PriorityKeys = "HighestPriority/Data" | "Core/SecondPriority" | string

type PriorityDict = { [PriorityKeys]: { ModuleScript } }

local Priorities: PriorityDict = {
	["HighestPriority/Data"] = {
		DataModules.GlobalPlayerDataRegistry :: ModuleScript,
	},
	["Core/SecondPriority"] = {
		Services.PlayerStatService :: ModuleScript,
		Services.InventoryService :: ModuleScript,
		Services.QuestService :: ModuleScript,
		Services.StateMachine :: ModuleScript,
		Services.ToolService :: ModuleScript,
	},
}

local LoaderFunctions = {
	["HighestPriority/Data"] = function(Player: Player?)
		for _, Modulescript: ModuleScript in Priorities["HighestPriority/Data"] do
			local RequiredModuleScript = require(Modulescript)

			if typeof(RequiredModuleScript) == "table" and typeof(RequiredModuleScript.Init) == "function" then
				RequiredModuleScript.Init(Player)
			end
		end

		LoadedHighestPriority = true
		warn("Loaded Highest priority Modules")
	end,
	["Core/SecondPriority"] = function(Player: Player)
		if not LoadedHighestPriority then
			return
		end

		for _, Modulescript in Priorities["Core/SecondPriority"] do
			local RequiredModuleScript = require(Modulescript) :: ModuleScript

			if typeof(RequiredModuleScript) == "table" and typeof(RequiredModuleScript.Init) == "function" then
				RequiredModuleScript.Init(Player)
			else
				continue
			end
		end
		warn("Loaded Second Priority Modules")
	end,
}

local ModuleLoader = {}

function ModuleLoader.LoadModules(Player: Player)
	LoaderFunctions["HighestPriority/Data"](Player)
	LoaderFunctions["Core/SecondPriority"](Player)
end

return ModuleLoader
