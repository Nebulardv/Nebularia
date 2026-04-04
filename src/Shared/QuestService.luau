local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local Data = Shared.Data
local QuestServiceModuleLocation = Services.QuestService
local QuestEngine = require(QuestServiceModuleLocation.QuestEngine)

local GlobalPlayerData = require(Data.GlobalPlayerData)

local QuestService = {}

local PlayerData = {}

function QuestService.RegisterPlayers(PlayerID: number)
	assert(typeof(PlayerID) == "number", "TargetID is not a number")
	if not GlobalPlayerData[PlayerID] then
		print("The Player's Data Does Not Exist")
		return
	end
	
	if not GlobalPlayerData[PlayerID].Quests then
		GlobalPlayerData[PlayerID].Quests = {}
	end
	
	print("Created Player Quest Data for: ".. tostring(PlayerID))
	
end


function QuestService.StartPlayerQuest(PlayerID: number, QuestID: string)
	assert(typeof(PlayerID) == "number", "TargetID is not a number")
	if not GlobalPlayerData[PlayerID] then
		print("The Player's Data Does Not Exist")
		return
	end
	
	if not GlobalPlayerData[PlayerID].Quests then
		print("The Player's Quest Data Does Not Exist")
		return
	end
	
	
	QuestEngine.StartQuest(PlayerData, PlayerID, QuestID)
end

function QuestService.ProcessEvent(PlayerID: number, Objective: string, ObjectiveTarget: string, IncrementAmount: number)
	assert(typeof(PlayerID) == "number", "TargetID is not a number")
	if not GlobalPlayerData[PlayerID] then
		print("The Player's Data Does Not Exist")
		return
	end
	if not GlobalPlayerData[PlayerID].Quests then
		print("The Player's Quest Data Does Not Exist")
		return
	end
	
	QuestEngine.ProgressQuest(PlayerData, PlayerID, Objective, ObjectiveTarget, IncrementAmount)
end

function QuestService.GetPlayerQuestData(PlayerID: number)
	assert(typeof(PlayerID) == "number", "TargetID is not a number")
	if not GlobalPlayerData[PlayerID] then
		print("The Player's Data Does Not Exist")
		return
	end
	if not GlobalPlayerData[PlayerID].Quests then
		print("The Player's Quest Data Does Not Exist")
		return
	end
	
	return GlobalPlayerData[PlayerID].Quests
end

function QuestService.Init(Player: Player?)
	if Player then
		QuestService.RegisterPlayers(
			Player.UserId
		)
	else
		error("No Player Argument passed In the Init function for ModuleScript: ".. script.Name)
	end
end

return QuestService
