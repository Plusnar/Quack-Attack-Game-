-- Script para gerar tráfego de carros no Roblox

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local carModels = ReplicatedStorage:WaitForChild("Carros") -- Pasta original para carros
local carModels2 = ReplicatedStorage:WaitForChild("Carros2") -- Nova pasta para carros da posição 2
local carModels3 = ReplicatedStorage:WaitForChild("Carros3") -- Pasta para carros da posição 3
local limite = workspace:WaitForChild("Limite") -- Parte Limite
local limite2 = workspace:WaitForChild("Limite2") -- Parte Limite2
local limite3 = workspace:WaitForChild("Limite3") -- Parte Limite3

-- Intervalos de spawn específicos para cada pasta de carros
local spawnIntervals = {
	[1] = 0.7,  -- Intervalo para Carros
	[2] = 0.3,  -- Intervalo para Carros2
	[3] = 0.5   -- Intervalo para Carros3
}

local velocidadeMaximaCarros = 100 -- Velocidade máxima dos carros padrão
local velocidadeMaximaCarros2 = 150 -- Velocidade máxima para carros da pasta Carros2
local velocidadeMaximaCarros3 = 200 -- Velocidade máxima para carros da pasta Carros3

-- Crie uma tabela com as posições de spawn
local spawnPositions = {
	Vector3.new(922.418, 1.942, -27.914), -- Posição 1
	Vector3.new(376.18, 0.079, 166.053), -- Posição 2
	Vector3.new(418.184, 1.324, -202.847) -- Posição 3
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

	-- Escolha o modelo de carro baseado na posição de spawn
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

	-- Posicionar o carro na posição de spawn
	carroModelo.Position = spawnPosition

	-- Defina o objetivo com base na posição de spawn
	local objetivo
	if spawnPosition == spawnPositions[1] then
		objetivo = limite.Position
	elseif spawnPosition == spawnPositions[2] then
		objetivo = limite2.Position
	else
		objetivo = limite3.Position
	end

	-- Criar a animação Tween para mover o carro
	local distancia = (objetivo - carroModelo.Position).Magnitude
	local tempo = distancia / velocidadeMaxima

	local tweenInfo = TweenInfo.new(tempo, Enum.EasingStyle.Linear)
	local tween = TweenService:Create(carroModelo, tweenInfo, {Position = objetivo})

	tween:Play()

	-- Adiciona evento de colisão ao carro
	carroModelo.Touched:Connect(function(other)
		onCarroTouched(carroModelo, other)
	end)

	tween.Completed:Connect(function()
		carroModelo:Destroy()
	end)
end

-- Função para iniciar o spawn de carros
local function iniciarSpawn()
	while true do
		local index = math.random(1, #spawnPositions) -- Escolhe aleatoriamente um índice de posição de spawn
		local spawnPosition = spawnPositions[index] -- Posição de spawn correspondente
		criarCarro(spawnPosition)

		-- Usar o spawnInterval correspondente à pasta de carros
		wait(spawnIntervals[index])
	end
end

-- Iniciar o spawn de carros
iniciarSpawn()
