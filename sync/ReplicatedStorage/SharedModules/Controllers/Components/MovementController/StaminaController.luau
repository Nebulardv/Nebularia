const RunService = game:GetService("RunService")
const ReplicatedStorage = game:GetService("ReplicatedStorage")
const Shared = ReplicatedStorage.SharedModules
const Data = Shared.Data
local ClientReplicatedData = require(Data.ClientReplicatedData)

local Connection
local RegenConnection
local StaminaController = {}

function StaminaController.DecreaseSprintStamina(Player: Player)
	local PlayerID = Player.UserId

	
	local ReplicatedStats = ClientReplicatedData.PlayerStats[PlayerID]
	if not ReplicatedStats then 
		warn("Stamina stats not replicated yet for player " .. PlayerID)
		return 
	end

	local StaminaDrainRate = ReplicatedStats.StaminaDrainRate
	if not StaminaDrainRate then return end

	if Connection and Connection.Connected then
		Connection:Disconnect()
	end

	Connection = RunService.Heartbeat:Connect(function(DeltaTime: number)
		local StaminaAttribute = Player:GetAttribute("Stamina") or 100
		local DeltaDrainRate = StaminaDrainRate * DeltaTime
		if StaminaAttribute > 0 then
			local NewStamina = math.max(0, StaminaAttribute - DeltaDrainRate)
			Player:SetAttribute("Stamina", NewStamina)
		end
	end)
end

function StaminaController.StopStaminaDecrease()
	if Connection and Connection.Connected then
		Connection:Disconnect()
		Connection = nil
	end
end

function StaminaController.RegenerateStamina(Player: Player)
	const PlayerID = Player.UserId

	
	if not ClientReplicatedData.PlayerStates[PlayerID] or ClientReplicatedData.PlayerStates[PlayerID].State == "Sprinting" then
		print("Cannot Regenerate; Player is in sprinting State or missing state data")
		return
	end

	local ReplicatedStats = ClientReplicatedData.PlayerStats[PlayerID]
	if not ReplicatedStats then 
		return 
	end

	local StaminaRegenRate = ReplicatedStats.StaminaRegenRate
	local StaminaRegenThreshold = ReplicatedStats.StaminaRegenThreshold

	if RegenConnection and RegenConnection.Connected then
		RegenConnection:Disconnect()
	end

	RegenConnection = RunService.Heartbeat:Connect(function(DeltaTime: number)
		local Stamina_Snapshot = Player:GetAttribute("Stamina") or 0
		if Stamina_Snapshot <= StaminaRegenThreshold then
			local RegenStamina = math.min(100, Stamina_Snapshot + (StaminaRegenRate * DeltaTime))
			Player:SetAttribute("Stamina", RegenStamina)
		end
		if Stamina_Snapshot >= 100 then
			RegenConnection:Disconnect()
		end
	end)
end

return StaminaController
