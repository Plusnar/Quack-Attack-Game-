-- LocalScript

-- Espera o jogador entrar
local player = game.Players.LocalPlayer

-- Espera o personagem ser criado
player.CharacterAdded:Connect(function(character)
	-- Espera o Humanoid ser criado
	local humanoid = character:WaitForChild("Humanoid")

	-- Define a velocidade de caminhada
	humanoid.WalkSpeed = 40

	-- Define a altura do pulo
	humanoid.JumpPower = 600
end)

-- Se o personagem já existir (caso o script seja reiniciado)
if player.Character then
	local humanoid = player.Character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = 30
	humanoid.JumpPower = 600
end
