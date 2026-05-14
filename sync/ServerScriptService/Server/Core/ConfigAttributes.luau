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
    ["Stamina"] = 100
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
