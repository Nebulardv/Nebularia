const Players = game:GetService("Players")
const Player = Players.LocalPlayer

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid") :: Humanoid

local PlayerGui = Player:WaitForChild("PlayerGui")
local MainUI = PlayerGui:WaitForChild("PlayerMain")
local HealthFrame: Frame = MainUI:WaitForChild("HealthFrame")
local HealthBar = HealthFrame:WaitForChild("HealthBar") :: TextLabel

local StaminaFrame: Frame = MainUI:WaitForChild("StaminaFrame")
local StaminaBar = StaminaFrame:WaitForChild("StaminaBar") :: TextLabel

local UIController = {}

function UIController.UpdateHealthBar()
	Humanoid.HealthChanged:Connect(function(NewHealth: number)
		HealthBar.AnchorPoint = Vector2.new(0, 1)
		HealthBar.Position = UDim2.new(0, 0, 1, 0)
		local NewY = NewHealth / 100
		HealthBar.Size = UDim2.new(1, 0, NewY, 0)
	end)
end

function UIController.UpdateStaminaBar()
	Player:GetAttributeChangedSignal("Stamina"):Connect(function()
		local Stamina = Player:GetAttribute("Stamina")
		StaminaBar.AnchorPoint = Vector2.new(0, 1)
		StaminaBar.Position = UDim2.new(0, 0, 1, 0)
		
		local NewY = math.clamp((Stamina / 100), 0, 1)

		StaminaBar.Size = UDim2.new(1,0,NewY,0)
	end)
end

function UIController.Init()
	UIController.UpdateHealthBar()
	UIController.UpdateStaminaBar()
end

return UIController
