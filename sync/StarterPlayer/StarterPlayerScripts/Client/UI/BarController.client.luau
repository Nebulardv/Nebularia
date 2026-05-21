const ReplicatedStorage = game:GetService("ReplicatedStorage")
const SharedModules = ReplicatedStorage.SharedModules
const ClientUI = SharedModules.ClientUI

local BarController = require(ClientUI.BarController)

BarController.Init()
