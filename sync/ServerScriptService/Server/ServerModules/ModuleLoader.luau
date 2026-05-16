--!strict
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const SharedModules = ReplicatedStorage.SharedModules
const DataModules = SharedModules.Data
const Services = SharedModules.Services
const StateMachine = Services.StateMachine
const ServerModules = script.Parent
const Server = ServerModules.Parent
const Core = Server.Core
const ServerDataModules = Server.Data

local LoadedHighestPriority = false

type PriorityKeys = "HighestPriority/Data" | "Core/SecondPriority" | string

type PriorityDict = { [PriorityKeys]: { ModuleScript } }

local Priorities: PriorityDict = {
	["HighestPriority/Data"] = {
		ServerDataModules.DataServiceLoad :: ModuleScript,
		DataModules.GlobalPlayerDataRegistry :: ModuleScript,
		ServerModules.InitializeLeaderstats :: ModuleScript,
		ServerDataModules.ReplicatorServer :: ModuleScript,
		Core.ConfigAttributes :: ModuleScript,
		StateMachine.StateResolverHub :: ModuleScript,
	},
	["Core/SecondPriority"] = {
		Services.PlayerStatService :: ModuleScript,
		Services.InventoryService :: ModuleScript,
		Services.QuestService :: ModuleScript,
		Services.StateMachine :: ModuleScript,
		Services.ToolService :: ModuleScript,
		Services.ChestsService :: ModuleScript,
		Services.LevelService :: ModuleScript,
	},
}

local LoaderFunctions = {
	["HighestPriority/Data"] = function(Player: Player?)
		for _, Modulescript: ModuleScript in Priorities["HighestPriority/Data"] do
			local success, ReturnedModule = pcall(function()
				return require(Modulescript) :: ModuleScript
			end)
			if not success then
				warn("Error Loading Module: " .. Modulescript.Name)
				return
			end

			if typeof(ReturnedModule) == "table" and typeof(ReturnedModule.Init) == "function" then
				ReturnedModule.Init(Player)
			else
				continue
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
			local success, ReturnedModule = pcall(function()
				return require(Modulescript) :: ModuleScript
			end)
			if not success then
				warn("Error Loading Module: " .. Modulescript.Name)
				return
			end

			if typeof(ReturnedModule) == "table" and typeof(ReturnedModule.Init) == "function" then
				ReturnedModule.Init(Player)
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
