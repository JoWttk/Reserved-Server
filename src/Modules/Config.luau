local Config={}

Config.Cooldown = 600
Config.PlaceId = game.PlaceId

function Config.CheckRanks(Player:Player)
	local Rank = Player.leaderstats.Rank
	local PatentesModule = require(game.ReplicatedStorage.Modules.Patentes)
	
	for i,v in pairs(PatentesModule) do
		if v.Name == Rank.Value then
			if v.Rank >= 7 then
				return true
			else
				return false
			end
		end
	end
end

return Config