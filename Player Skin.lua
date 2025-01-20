local rep = game:GetService("ReplicatedStorage")
local hats = {
	["UnivilleA"] = rep.Pato1,
	["UnivilleB"] = rep.Pato2,
	["UnivilleC"] = rep.Pato3
}

game.Players.PlayerAdded:Connect(function(player)
	if hats[player.Name] then
		player.CharacterAdded:Connect(function(character)
			-- Clonar o chapéu correspondente e adicioná-lo ao personagem
			local hat = hats[player.Name]:Clone()
			hat.Parent = character

			-- Tornar o restante do corpo invisível
			for _, part in pairs(character:GetChildren()) do
				if part:IsA("BasePart") and part.Name ~= hat.Name then
					part.Transparency = 1
				end
			end
		end)
	end
end)
