local AttributesConfig = {}

local Players = game:GetService("Players")

type Attribute = {[string]: boolean 

    | string 
    | number 
    | Color3 

    | Vector2 
    | Vector3 
    | BrickColor 

    | CFrame  
    | UDim 
    | UDim2

}
const Attributes: Attribute = {
	["Stamina"] = 100,
	["MaxHealth"] = 100,
	["DamageMultiplier"] = 1,
	["Armor"] = 0,
	["Speed"] = 20,
	["JumpHeight"] = 7.2,
	["AttackingSpeedDifference"] = 5,
	["AttackingJumpHeightDifference"] = 4,
	["BlockingSpeedDifference"] = 10,
	["BlockingJumpHeightDifference"] = 5,
	["HealthRegenRate"] = 10,
	["MaxStamina"] = 100,
	["StaminaRegenRate"] = 5,
	["StaminaDrainRate"] = 5,
	["SprintSpeedDifference"] = 15,
	["StaminaRegenDelay"] = 5,
	["StunnedSpeedDifferenceMultiplier"] = 0.1,
	["StaminaRegenThreshold"] = 20,
}


const function ApplyAttributes(Player: Player)
    for AttributeName, AttributeValue in Attributes do
        Player:SetAttribute(AttributeName, AttributeValue)
    end
end

function AttributesConfig.Init()
	for _, PlayerInGame in Players:GetPlayers() do
        ApplyAttributes(PlayerInGame)
	end

	Players.PlayerAdded:Connect(function(Player: Player)
		ApplyAttributes(Player)
	end)
end

return AttributesConfig
