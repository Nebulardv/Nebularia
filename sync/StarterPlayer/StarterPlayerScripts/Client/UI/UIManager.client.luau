local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

local UIController = require(script.Parent.UIController)

Humanoid.HealthChanged:Connect(function(NewHealth:number)
	UIController.UpdateHealthBar(NewHealth)
end)

Player:GetAttributeChangedSignal("Stamina"):Connect(function()
	local Stamina = Player:GetAttribute("Stamina")
	local RoundedStamina = math.floor(Stamina)
	
	UIController.UpdateStaminaBar(RoundedStamina)
end)


--[[while true do
	task.wait(1)
	Humanoid.Health -= 5
end]]
