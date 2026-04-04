local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Types = Shared.Types

local GlobalPlayerDataTypeModule = require(Types.GlobalPlayerDataType)
type GlobalPlayerDataType = GlobalPlayerDataTypeModule.GlobalPlayerData

local GlobalPlayerDataTable: GlobalPlayerDataType = {}

return GlobalPlayerDataTable
