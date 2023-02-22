--[[
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
MADE BY Simoniko#3550
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--]]


local players = game:GetService("Players")
local plr = players.LocalPlayer
local camera = game.workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local tw = game:GetService("TweenService")
local holding = false

-- aimbot cfg / settings
_G.AimbotEnabled = true
_G.TeamCheck = true
_G.AimPart = "Head"
_G.Sensitivity = 0 --how many seconds to lock on a player 3 for legit ig

-- fov circle cfg / settings
_G.CircleSides = 64 -- how many sides
_G.CircleColor = Color3.fromRGB(255, 255, 255)
_G.CircleTransparency = 0.7
_G.CircleRadius = 80 --size of the circle
_G.CircleFilled = false -- false = okrąg
_G.CircleVisible = true
_G.CircleThickness = 0

local fovcircle = Drawing.new("Circle")
fovcircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
fovcircle.Radius = _G.CircleRadius
fovcircle.Filled = _G.CircleFilled
fovcircle.Color = _G.CircleColor
fovcircle.Visible = _G.CircleVisible
fovcircle.Radius = _G.CircleRadius
fovcircle.Transparency = _G.CircleTransparency
fovcircle.NumSides = _G.CircleSides
fovcircle.Thickness = _G.CircleThickness

local function GetClosestPlr()
	local MaximumDist = _G.CircleRadius
	local target = nil

	for _, v in next, players:GetPlayers() do
		if v.Name ~= plr.Name then
			if _G.TeamCheck == true then
				if v.Team ~= plr.Team then
					if v.Character ~= nil then
						if v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
							if v.Character:FindFirstChild("HumanoidRootPart") then
								local screenpoint = camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
								local vectordist = (Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y) - Vector2.new(screenpoint.X, screenpoint.Y)).Magnitude

								if vectordist < MaximumDist then
									target = v
								end
							end
						end
					end
				end
			else
				if v.Character ~= nil then
					if v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 then
						if v.Character:FindFirstChild("HumanoidRootPart") then
							local screenpoint = camera:WorldToScreenPoint(v.Character:WaitForChild("HumanoidRootPart", math.huge).Position)
							local vectordist = (Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y) - Vector2.new(screenpoint.X, screenpoint.Y)).Magnitude

							if vectordist < MaximumDist then
								target = v
							end
						end
					end
				end
			end
		end
	end

	return target
end

uis.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		holding = true
	end
end)

uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		holding = false
	end
end)

game.RunService.RenderStepped:Connect(function()
	fovcircle.Position = Vector2.new(uis:GetMouseLocation().X, uis:GetMouseLocation().Y)
	fovcircle.Radius = _G.CircleRadius
	fovcircle.Filled = _G.CircleFilled
	fovcircle.Color = _G.CircleColor
	fovcircle.Visible = _G.CircleVisible
	fovcircle.Radius = _G.CircleRadius
	fovcircle.Transparency = _G.CircleTransparency
	fovcircle.NumSides = _G.CircleSides
	fovcircle.Thickness = _G.CircleThickness

	if holding == true and _G.AimbotEnabled == true then
		game:GetService("TweenService"):Create(camera, TweenInfo.new(_G.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(camera.CFrame.Position, GetClosestPlr().Character[_G.AimPart].Position)}):Play()
	end
end)
