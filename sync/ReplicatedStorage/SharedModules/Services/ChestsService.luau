local ReplicatedStorage = game:GetService("ReplicatedStorage")
local _TweenService = game:GetService("TweenService")

local WorkspaceAssets = workspace.Assets
local _ChestsFolder = WorkspaceAssets.Chests

local _SharedModules = ReplicatedStorage.SharedModules
local _Chests = require(script.Chests)
local Services = _SharedModules.Services
local _InventoryService = require(Services.InventoryService)

local ChestsService = {}

return ChestsService
