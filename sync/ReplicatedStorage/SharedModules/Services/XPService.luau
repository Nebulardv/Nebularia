const Players = game:GetService("Players")
const ReplicatedStorage = game:GetService("ReplicatedStorage")

const Shared = ReplicatedStorage.SharedModules
const Events = ReplicatedStorage.Events
const Signals = Events.Signals
const Data = Shared.Data

const OnXPModifiedSignal = Signals.OnXPModifiedSignal :: BindableEvent

local GlobalPlayerData = require(Data.GlobalPlayerData)

local XPService = {}

const function CheckXPData(Condition, PlayerID)
	if not Condition then
		warn("ID: " .. PlayerID .. " Does not have an XP value in their Data, Returning")
		return
	end
end

function XPService.IncreaseXP(Amount: number, PlayerID: number)
	local Player = Players:GetPlayerByUserId(PlayerID)

	CheckXPData(GlobalPlayerData[PlayerID].XP, PlayerID)
	GlobalPlayerData[PlayerID].XP += Amount

	local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
	local XP = leaderstats:FindFirstChild("XP") :: IntValue

	if not XP or not leaderstats then
		print("LEADERSTATS FOLDER OR XP INTVALUE DOES NOT EXIST FOR: " .. PlayerID)
		return
	end

	XP.Value += Amount

	const NewXP = GlobalPlayerData[PlayerID].XP

	OnXPModifiedSignal:Fire(PlayerID, NewXP)
end

function XPService.DecreaseXP(Amount: number, PlayerID: number)
	CheckXPData(GlobalPlayerData[PlayerID].XP, PlayerID)

	local Player = Players:GetPlayerByUserId(PlayerID)

	local leaderstats = Player:FindFirstChild("leaderstats") :: Folder
	local XP = leaderstats:FindFirstChild("XP") :: IntValue

	if not XP or not leaderstats then
		print("LEADERSTATS FOLDER OR XP INTVALUE DOES NOT EXIST FOR: " .. PlayerID)
		return
	end

	XP.Value -= Amount

	GlobalPlayerData[PlayerID].XP -= Amount
	const NewXP = GlobalPlayerData[PlayerID].XP
	OnXPModifiedSignal:Fire(PlayerID, NewXP)
end

function XPService.GetXP(PlayerID: number)
	CheckXPData(GlobalPlayerData[PlayerID].XP, PlayerID)
	return GlobalPlayerData[PlayerID].XP
end

function XPService.HasEnoughXP(PlayerID: number, Requirement: number): boolean
	CheckXPData(GlobalPlayerData[PlayerID].XP, PlayerID)
	return GlobalPlayerData[PlayerID].XP >= Requirement
end

return XPService
