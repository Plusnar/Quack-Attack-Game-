-- Script para gerar tr�fego de carros no Roblox

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local carModels = ReplicatedStorage:WaitForChild("Carros") -- Pasta original para carros
local carModels2 = ReplicatedStorage:WaitForChild("Carros2") -- Nova pasta para carros da posi��o 2
local carModels3 = ReplicatedStorage:WaitForChild("Carros3") -- Pasta para carros da posi��o 3
local limite = workspace:WaitForChild("Limite") -- Parte Limite
local limite2 = workspace:WaitForChild("Limite2") -- Parte Limite2
local limite3 = workspace:WaitForChild("Limite3") -- Parte Limite3

-- Intervalos de spawn espec�ficos para cada pasta de carros
local spawnIntervals = {
	[1] = 0.7,  -- Intervalo para Carros
	[2] = 0.3,  -- Intervalo para Carros2
	[3] = 0.5   -- Intervalo para Carros3
}

local velocidadeMaximaCarros = 100 -- Velocidade m�xima dos carros padr�o
local velocidadeMaximaCarros2 = 150 -- Velocidade m�xima para carros da pasta Carros2
local velocidadeMaximaCarros3 = 200 -- Velocidade m�xima para carros da pasta Carros3

-- Crie uma tabela com as posi��es de spawn
local spawnPositions = {
	Vector3.new(922.418, 1.942, -27.914), -- Posi��o 1
	Vector3.new(376.18, 0.079, 166.053), -- Posi��o 2
	Vector3.new(418.184, 1.324, -202.847) -- Posi��o 3
}

local function onCarroTouched(carroModelo, other)
	local player = game.Players:GetPlayerFromCharacter(other.Parent)
	if player then
		local humanoid = other.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:TakeDamage(200) -- Aplica 20 de dano ao jogador
		end
	end
end

local function criarCarro(spawnPosition)
	local carroModelo
	local velocidadeMaxima

	-- Escolha o modelo de carro baseado na posi��o de spawn
	if spawnPosition == spawnPositions[1] then
		carroModelo = carModels:GetChildren()[math.random(1, #carModels:GetChildren())]:Clone()
		velocidadeMaxima = velocidadeMaximaCarros
	elseif spawnPosition == spawnPositions[2] then
		carroModelo = carModels2:GetChildren()[math.random(1, #carModels2:GetChildren())]:Clone()
		velocidadeMaxima = velocidadeMaximaCarros2
	else
		carroModelo = carModels3:GetChildren()[math.random(1, #carModels3:GetChildren())]:Clone()
		velocidadeMaxima = velocidadeMaximaCarros3
	end

	carroModelo.Parent = workspace

	-- Posicionar o carro na posi��o de spawn
	carroModelo.Position = spawnPosition

	-- Defina o objetivo com base na posi��o de spawn
	local objetivo
	if spawnPosition == spawnPositions[1] then
		objetivo = limite.Position
	elseif spawnPosition == spawnPositions[2] then
		objetivo = limite2.Position
	else
		objetivo = limite3.Position
	end

	-- Criar a anima��o Tween para mover o carro
	local distancia = (objetivo - carroModelo.Position).Magnitude
	local tempo = distancia / velocidadeMaxima

	local tweenInfo = TweenInfo.new(tempo, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(carroModelo, tweenInfo, {Position = objetivo})

	tween:Play()

	-- Adiciona evento de colis�o ao carro
	carroModelo.Touched:Connect(function(other)
		onCarroTouched(carroModelo, other)
	end)

	tween.Completed:Connect(function()
		carroModelo:Destroy()
	end)
end

-- Fun��o para iniciar o spawn de carros
local function iniciarSpawn()
	while true do
		local index = math.random(1, #spawnPositions) -- Escolhe aleatoriamente um �ndice de posi��o de spawn
		local spawnPosition = spawnPositions[index] -- Posi��o de spawn correspondente
		criarCarro(spawnPosition)

		-- Usar o spawnInterval correspondente � pasta de carros
		wait(spawnIntervals[index])
	end
end

-- Iniciar o spawn de carros
iniciarSpawn()
