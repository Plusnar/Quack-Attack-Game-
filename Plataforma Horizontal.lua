-- Define variables
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Create RemoteEvent for platform control
local platformControlEvent = Instance.new("RemoteEvent")
platformControlEvent.Name = "PlatformControl2"
platformControlEvent.Parent = replicatedStorage

-- Get the part representing the platform
local platform = game.Workspace:WaitForChild("Platform") -- Ensure the platform exists in Workspace

-- Set debounce to false
local platformDebounce = false

-- Store the original position of the platform
local originalPosition = platform.Position

-- Calculate the bounds of the region
local buttonPart = game.Workspace:WaitForChild("Button1") -- Ensure Button1 exists in Workspace
local pointA = (buttonPart.CFrame + (buttonPart.CFrame.LookVector * buttonPart.Size.Z / 2) +
	(buttonPart.CFrame.RightVector * buttonPart.Size.X / 2) +
	(buttonPart.CFrame.UpVector * buttonPart.Size.Y / 2)).Position
local pointB = (buttonPart.CFrame - (buttonPart.CFrame.LookVector * buttonPart.Size.Z / 2) -
	(buttonPart.CFrame.RightVector * buttonPart.Size.X / 2) -
	(buttonPart.CFrame.UpVector * buttonPart.Size.Y / 2)).Position

local region = Region3.new(
	Vector3.new(
		math.min(pointA.X, pointB.X),
		math.min(pointA.Y, pointB.Y),
		math.min(pointA.Z, pointB.Z)
	),
	Vector3.new(
		math.max(pointA.X, pointB.X),
		math.max(pointA.Y, pointB.Y),
		math.max(pointA.Z, pointB.Z)
	)
)

local tweenInfo = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) -- 4 seconds duration

-- Function to control the platform's position
local function controlPlatform(isRaising)
	local targetPosition = isRaising and (originalPosition + Vector3.new(0, 38, 0)) or originalPosition
	local tween = TweenService:Create(platform, tweenInfo, {Position = targetPosition})
	tween:Play()
	tween.Completed:Wait()
end

-- Detect players in the region
RunService.RenderStepped:Connect(function()
	local playersInArea = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			local parts = workspace:FindPartsInRegion3WithWhiteList(region, {player.Character}, math.huge)
			if table.find(parts, player.Character:FindFirstChild("HumanoidRootPart")) then
				table.insert(playersInArea, player)
			end
		end
	end

	if #playersInArea > 0 and not platformDebounce then
		platformDebounce = true
		controlPlatform(true)
		platformControlEvent:FireAllClients(true) -- Notify clients to raise the platform
	elseif #playersInArea == 0 and platformDebounce then
		platformDebounce = false
		controlPlatform(false)
		platformControlEvent:FireAllClients(false) -- Notify clients to lower the platform
	end
end)

-- Handle client requests to raise/lower platform
platformControlEvent.OnServerEvent:Connect(function(player, action)
	if action == "raise" and not platformDebounce then
		platformDebounce = true
		controlPlatform(true)
	elseif action == "lower" and platformDebounce then
		platformDebounce = false
		controlPlatform(false)
	end
end)
