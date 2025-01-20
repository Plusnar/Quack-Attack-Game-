-- define variables 

-- get local player
local player = game.Players.LocalPlayer  

-- get the camera
local camera = workspace.CurrentCamera
local character = player.Character or player.CharacterAdded:Wait(4)
-- get the part
local part = game.Workspace.mazepart

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
	for i, v in pairs(parts) do
		if v.Name == "HumanoidRootPart" then
			camera.CameraType = Enum.CameraType.Scriptable

			local targetDistance = 30
			local cameraHeight = 70  -- Set a height for the camera

			-- Top-down view
			local cameraPosition = Vector3.new(character.HumanoidRootPart.Position.X, character.HumanoidRootPart.Position.Y + cameraHeight, character.HumanoidRootPart.Position.Z)

			if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
				local head = character.HumanoidRootPart
				camera.Focus = head.CFrame

				-- Adjust the camera's coordinate frame
				camera.CoordinateFrame = CFrame.new(cameraPosition, head.Position)
			end
		end
	end
	if table.find(parts, character:FindFirstChild("HumanoidRootPart")) == nil then
		camera.CameraSubject = character.Humanoid
		camera.CameraType = Enum.CameraType.Custom
	end
end)
