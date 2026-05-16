const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Players = game:GetService("Players")

const Events = ReplicatedStorage.Events
const Signals = Events.Signals
const OnXpModifiedSignal = Signals.OnXPModifiedSignal :: BindableEvent

const SharedModules = ReplicatedStorage.SharedModules
const Data = SharedModules.Data
const Levels = require(Data.Levels)

local GlobalPlayerData = require(Data.GlobalPlayerData)

const LevelService = {}

const function GetLevelFromXP(XP: number)
	for i = #Levels, 1, -1 do
		const XP_REQUIREMENT = Levels[i]

		if XP >= XP_REQUIREMENT then
			return i
		end
	end
	return 1
end
-- Loops through the levels from the highest index to 1, decreasing by one, then checking the xp needed. if the xp parameter
-- is greater than or equal to the requirement, it returnes the index(number) which is what the EIK Array is keyed by
-- EIK -> EXPLICIT INTEGER KEYS

function LevelService.SetLevel(PlayerID: number, Level: number)
	local Player = Players:GetPlayerByUserId(PlayerID)

	local leaderstats = Player:WaitForChild("leaderstats") :: Folder
	local LevelValue = leaderstats:WaitForChild("Level") :: IntValue

	if not LevelValue or not leaderstats then
		print("LEADERSTATS FOLDER OR Level INTVALUE DOES NOT EXIST FOR: " .. PlayerID)
		return
	end

	if not GlobalPlayerData[PlayerID].Level then
		warn("Level Data does not exist in GlobalData for: " .. PlayerID)
		return
	end
	GlobalPlayerData[PlayerID].Level = Level -- IMPORTANT; Set GlobalPlayerData[PlrId].Level = Level and NOT += Level
	LevelValue.Value = Level
end

OnXpModifiedSignal.Event:Connect(function(PlayerID, NewXP)
	const EvaluatedLevel = GetLevelFromXP(NewXP)
	LevelService.SetLevel(PlayerID, EvaluatedLevel)
end)

return LevelService
