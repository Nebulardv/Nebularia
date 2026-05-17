--[[
    @ BetterSpawn.SpawnEntityInRandomPosition()
      - PARAMETERS:
        - AreaPadding -> Describes the inline bounds an entity is allowed to spawn in(e.g 5 studs away from edge)
        - AreaSize -> The Total Size of the Area given in form of a Vector3
        - AreaCFrame -> The CFrame of the Area. Allows for clean positional data which automatically handles rotation, unlike a Vector3 value
        - Y_Padding -> How much ABOVE the Y axis we want the Entity To spawn, e.g 1 stud above the Y coordinate value

]]

const Areas = require("@self/Areas")
const RNG = Random.new()

local BetterSpawn = {}

const function GetRandomCFrame(AreaPadding: number, AreaSize: Vector3, AreaCFrame: CFrame, Y_Padding: number)
	const HALF_SIZE_X = AreaSize.X / 2 :: number
	const HALF_SIZE_Z = AreaSize.Z / 2 :: number
	const Y = math.floor(AreaSize.Y / 2) :: number

	const PADDED_X = (HALF_SIZE_X - AreaPadding) :: number
	const PADDED_Z = (HALF_SIZE_Z - AreaPadding) :: number
	const PADDED_Y = (Y + Y_Padding) :: number

	const RANDOM_X_OFFSET = RNG:NextInteger(-PADDED_X, PADDED_X)
	const RANDOM_Z_OFFSET = RNG:NextInteger(-PADDED_Z, PADDED_Z)

	const RANDOM_CFRAME = AreaCFrame * CFrame.new(RANDOM_X_OFFSET, PADDED_Y, RANDOM_Z_OFFSET)

	return RANDOM_CFRAME
end

function BetterSpawn.SpawnEntityInRandomPosition(AreaName: string)
	const AreaData = Areas[AreaName]
	assert(AreaData, "No AreaData found")

	const Size = AreaData.Size
	const CFrame = AreaData.CFrame
	const Padding = AreaData.Padding
	const Y_Padding = AreaData.Y_Padding

	const EntityObject = AreaData.EntityObject :: Model | UnionOperation | BasePart
	local Object = EntityObject.Object:Clone()

	const RandomCFrame = GetRandomCFrame(Padding, Size, CFrame, Y_Padding)

	Object.Parent = AreaData.Area
	Object:PivotTo(RandomCFrame)

	AreaData.CurrentEntities += 1
end

return BetterSpawn
