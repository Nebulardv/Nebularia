const RunService = game:GetService("RunService")
const ReplicatedStorage = game:GetService("ReplicatedStorage")

const Shared  = ReplicatedStorage.SharedModules
const Data = Shared.Data
const ClientReplicatedData = require(Data.ClientReplicatedData)

local Connection
local RegenConnection

local StaminaController = {}

function StaminaController.DecreaseSprintStamina(Player: Player)

    const PlayerID = Player.UserId
    
    const ReplicatedStats = ClientReplicatedData.PlayerStats[PlayerID]

    local StaminaDrainRate = ReplicatedStats.StaminaDrainRate

    if Connection and Connection.Connected then
        Connection:Disconnect()
    end

    Connection = RunService.Heartbeat:Connect(function(DeltaTime: number)
        local StaminaAttribute = Player:GetAttribute("Stamina")
        local DeltaDrainRate = StaminaDrainRate * DeltaTime

        if StaminaAttribute > 0 then
            local NewStamina = StaminaAttribute - DeltaDrainRate
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
    if ClientReplicatedData.PlayerStates[Player.UserId].State == "Sprinting" then
        print("Cannot Regenerate; Player is in sprinting State")
        return
    end

    const StaminaRegenRate = ClientReplicatedData.PlayerStats[Player.UserId].StaminaRegenRate
    const StaminaRegenThreshold = ClientReplicatedData.PlayerStats[Player.UserId].StaminaRegenThreshold

    if RegenConnection and RegenConnection.Connected then
        RegenConnection:Disconnect()
    end
    RegenConnection = RunService.Heartbeat:Connect(function(DeltaTime: number)
        const Stamina_Snapshot = Player:GetAttribute("Stamina")
        if Stamina_Snapshot <= StaminaRegenThreshold then
            const RegenStamina = Stamina_Snapshot + (StaminaRegenRate * DeltaTime)
            Player:SetAttribute("Stamina", RegenStamina)
        end

        if Stamina_Snapshot >= 100 then
            RegenConnection:Disconnect()
        end
    
    end)
  
end



return StaminaController 