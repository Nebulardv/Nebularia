local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Assets = ReplicatedStorage.Assets
local ChestsFolder = Assets.Chests

local _SharedModules = ReplicatedStorage.SharedModules
local Chests = require(script.Chests)

local RNG = Random.new()

-- // Constants

local OpenTime = 0.6
local ItemTweenUpTime = 0.5
local _WT = 0

local ChestsService = {}

function ChestsService.GetRandomItem(ChestName: string)
	local Chest = Chests[ChestName]
	if not Chest then
		print("Chest Not Found in ChestsTable")
		return
	end
	local Items = Chest.Items
	if not Items then
		print("No Items found in: " .. ChestName)
		return
	end

	local NumberOfItems = 0

	for _, Item in Items do
		NumberOfItems += 1
	end

	local RandomNum = RNG:NextInteger(1, NumberOfItems)

	local RandomItem = Items[RandomNum]

	return RandomItem :: Model | UnionOperation | BasePart
end

function ChestsService.OpenChest(ChestName: string)
	local RandomItemFromChest = ChestsService.GetRandomItem(ChestName):Clone()
	local Chest = ChestsFolder[RandomItemFromChest] :: Model

	local Top = Chest.Top or Chest.PrimaryPart :: BasePart

	local ORIGINALTOPCFRAME = Top.CFrame :: CFrame

	if not Top or not Chest.PrimaryPart then
		print("Chest does not have Top / PrimaryPart")
		return
	end

	RandomItemFromChest.CFrame = Top.CFrame * CFrame.new(0, -3, 0)
	RandomItemFromChest.Anchored = true
	RandomItemFromChest.Parent = Chest

	local TopTween: Tween = TweenService.Create(
		Top,
		TweenInfo.new(OpenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ CFrame = (Top.CFrame * CFrame.new(0, 0, 5)) }
	):Play()

	TopTween.Completed:Connect(function()
		local ItemTweenUp = TweenService.Create(
			RandomItemFromChest,
			TweenInfo.new(ItemTweenUpTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ CFrame = (ORIGINALTOPCFRAME * CFrame.new(0, 5, 0)) }
		):Play()
	end)
end
return ChestsService
