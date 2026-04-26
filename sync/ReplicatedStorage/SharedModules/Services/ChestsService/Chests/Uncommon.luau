local TweenService = game:GetService("TweenService")

local Chests = require("../Chests")
local UncommonChestData = Chests["Uncommon Chest" :: "Uncommon Chest"]

const function AnchorModel(Model: Model)
	for _, part in Model:GetDescendants() do
		if part:IsA("BasePart") or part:IsA("UnionOperation") or part:IsA("MeshPart") then
			part.Anchored = true
		end
	end
end


return function(ChestModel: Model, Item: Model)
	local Top = ChestModel.PrimaryPart :: BasePart
	if not Top then
		print("Top Not Found")
		return
	end

	local ItemOffset = UncommonChestData.Data.ItemPositionOffset
    local ItemRotationOffsetCFrame = UncommonChestData.Data.ItemRotationOffsetCFrame
	Item:PivotTo(Top.CFrame * CFrame.new(0, ItemOffset, 0) * ItemRotationOffsetCFrame)
    AnchorModel(Item)
	local ItemsFolder = ChestModel:FindFirstChild("Items") :: Folder
	Item.Parent = ItemsFolder

	local OpenPosOffset = UncommonChestData.Data.OpenPositionOffset

	local OpenTween: Tween = TweenService:Create(
		ChestModel.PrimaryPart :: BasePart | UnionOperation,
		TweenInfo.new(UncommonChestData.Data.OpenTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{
			CFrame = (ChestModel.PrimaryPart :: BasePart | UnionOperation).CFrame * CFrame.new(0, 0, OpenPosOffset),
		}
	)
	OpenTween:Play()

	return true
end
