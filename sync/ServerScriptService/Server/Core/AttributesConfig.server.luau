local Players = game:GetService("Players")

for _, Player in Players:GetPlayers() do
	Player:SetAttribute("Stamina", 100)
end

Players.PlayerAdded:Connect(function(Player: Player)
	Player:SetAttribute("Stamina", 100)
end)