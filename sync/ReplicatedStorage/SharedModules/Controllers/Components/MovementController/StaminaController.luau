const RunService = game:GetService("RunService")
const ReplicatedStorage = game:GetService("ReplicatedStorage")

const Shared  = ReplicatedStorage.SharedModules
const Data = Shared.Data
const ClientReplicatedData = require(Data.ClientReplicatedData)

local Connection

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



return StaminaController 