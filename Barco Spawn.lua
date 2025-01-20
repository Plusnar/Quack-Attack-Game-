local replicatedStorage = game:GetService("ReplicatedStorage")
local woodCollectedEvent = Instance.new("RemoteEvent", replicatedStorage)
woodCollectedEvent.Name = "WoodCollected"

local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")

local totalWoods = 8  -- Total de madeiras a coletar
local totalCollectedWoods = 0  -- Contagem total de madeiras coletadas por todos os jogadores
local validWoods = {"wood1", "wood2", "wood3", "wood4", "wood5", "wood6", "wood7", "wood8"}

local function createBoat(position)
	local model = lighting:FindFirstChild("Barco")  -- Substitua "Barco" pelo nome do seu modelo no Lighting
	if model then
		local newModel = model:Clone()  -- Clona o modelo
		newModel.Parent = workspace  -- Adiciona o modelo ao workspace
		newModel.Position = position  -- Define a posição desejada
		print("Modelo apareceu no Workspace!")  -- Debug
	else
		print("Modelo não encontrado no Lighting.")  -- Debug
	end
end

local function collectWood(player, wood)
	if wood:IsA("MeshPart") and table.find(validWoods, wood.Name) then
		wood:Destroy()  -- Remove a madeira
		totalCollectedWoods = totalCollectedWoods + 1  -- Incrementa a contagem total de madeira

		print("Total collected woods: " .. totalCollectedWoods)  -- Debug
		woodCollectedEvent:FireAllClients(totalCollectedWoods)  -- Envia a contagem atualizada de madeira para todos os jogadores

		-- Verifica se coletou a quantidade total de madeiras
		if totalCollectedWoods >= totalWoods then
			-- Cria o barco na posição desejada
			createBoat(Vector3.new(261.539, -4.987, -155.465))  -- Defina a posição desejada
		end
	end
end

-- Função chamada ao tocar um objeto
local function onTouch(hit, player)
	collectWood(player, hit)
end

players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

		humanoidRootPart.Touched:Connect(function(hit)
			onTouch(hit, player)
		end)
	end)
end)
