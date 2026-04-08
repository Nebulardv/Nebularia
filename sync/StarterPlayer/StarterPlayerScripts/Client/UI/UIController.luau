local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")
local MainUI = PlayerGui:WaitForChild("PlayerMain")
local HealthFrame: Frame = MainUI:WaitForChild("HealthFrame")
local HealthBar: TextLabel = HealthFrame:WaitForChild("HealthBar")

local StaminaFrame: Frame = MainUI:WaitForChild("StaminaFrame")
local StaminaBar: TextLabel = StaminaFrame:WaitForChild("StaminaBar")

local UIController = {}

function UIController.UpdateHealthBar(Health: number)
	local NewX = Health / 100
	local HealthTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	TweenService:Create(
		HealthBar,
		HealthTweenInfo,
		{ 
			Size = UDim2.new(
				NewX, 0 , 1 ,0
			) 
		}
	):Play()
end

function UIController.UpdateStaminaBar(Stamina: number)
	
	local NewX = math.clamp((Stamina / 100), 0, 1)
	
	local StaminaTweeninfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	
	TweenService:Create(
		StaminaBar,
		StaminaTweeninfo,
		{ 
			Size = UDim2.new(
				NewX, 0 , 1 ,0
			) 
		}
	):Play()
end

return UIController 