-- define variables 

-- get local player
local player = game.Players.LocalPlayer  

-- get the camera
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait()
-- get the part
local part = game.Workspace.camerapart

-- set debounce to false
local debounce = false

local touching = false

-- set up on touched function

local pointA = (part.CFrame + (part.CFrame.LookVector * part.Size.Z/2) + (part.CFrame.RightVector * part.Size.X/2) + (part.CFrame.UpVector * part.Size.Y/2)).Position
local pointB = (part.CFrame - (part.CFrame.LookVector * part.Size.Z/2) - (part.CFrame.RightVector * part.Size.X/2) - (part.CFrame.UpVector * part.Size.Y/2)).Position

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

game:GetService("RunService").RenderStepped:Connect(function()
	local parts = workspace:FindPartsInRegion3WithWhiteList(region, {character}, math.huge)
	for i,v in pairs(parts) do
		if v.Name == "HumanoidRootPart" then
			camera.CameraType = Enum.CameraType.Scriptable

			local targetDistance = 30
			local cameraDistance = -70
			local cameraDirection = Vector3.new(0, -0.3, 1)  -- Change this to point along the negative Z-axis

			local currentTarget = cameraDirection * targetDistance
			local currentPosition = cameraDirection * cameraDistance

			if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
				local head = character.HumanoidRootPart
				camera.Focus = head.CFrame
				if head:FindFirstChild("FastStart") == nil then
					camera.CoordinateFrame = CFrame.new(
						Vector3.new(head.Position.X, head.Position.Y, head.Position.Z) + currentPosition, 
						Vector3.new(head.Position.X, head.Position.Y, head.Position.Z) + currentTarget
					)
				else
					--Lower camera for fast start
					camera.CoordinateFrame = CFrame.new(
						Vector3.new(head.Position.X, head.Position.Y - 0, head.Position.Z) + currentPosition, 
						Vector3.new(head.Position.X, head.Position.Y - 0, head.Position.Z) + currentTarget
					)
				end
			end
		end
	end
	if table.find(parts, character:FindFirstChild("HumanoidRootPart")) == nil then
		game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
	end
end)
