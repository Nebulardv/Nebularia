local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local _Humanoid: Humanoid = Character:WaitForChild("Humanoid")

local UIController = require(script.Parent.UIController)

UIController.Init()
