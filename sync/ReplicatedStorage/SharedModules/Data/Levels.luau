const BASE_XP = 1000
const MAX_LEVEL = 100
const INCREMENT_EXPONENT = 1.2

local Levels = table.create(MAX_LEVEL)

for Level = 1, MAX_LEVEL do
	Levels[Level] = math.floor(BASE_XP * (Level ^ INCREMENT_EXPONENT))
end

return table.freeze(Levels)
