local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local Player = game:GetService("Players").LocalPlayer
local Char =  Player.Character or Player.CharacterAdded:Wait()
local Hum = Char:WaitForChild("Humanoid")
local HRP = Char:WaitForChild("HumanoidRootPart")

local Cam = workspace.CurrentCamera
local LockOn = false

local Target

function FindNearestTarget(HRP)
	local TargetDistance = 50
	local Target
	
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") and v.Name ~= Char.Name then
			local TargetHRP = v.HumanoidRootPart
			local Mag = (HRP.Position - TargetHRP.Position).Magnitude
			if Mag < TargetDistance then
				TargetDistance = Mag
				Target = TargetHRP
			end
		end
	end
	return Target
end

function M2(Action)
	if Action == "Off" then
		ContextActionService:BindActionAtPriority("DisableM2", function()
			return Enum.ContextActionResult.Sink
		end, false, Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseButton2)
	elseif Action == "On" then
		ContextActionService:BindActionAtPriority("DisableM2", function()
			return Enum.ContextActionResult.Pass
		end, false, Enum.ContextActionPriority.High.Value,Enum.UserInputType.MouseButton2)
	end
end

UIS.InputBegan:Connect(function(Key,IsTyping)
	if IsTyping then return end
	
	if Key.KeyCode == Enum.KeyCode.P then
		if LockOn then
			LockOn = false
			Target = nil
			Hum.AutoRotate = true
			M2("On")
			UIS.MouseIconEnabled = true
		else
			LockOn = true
			Target = FindNearestTarget(HRP)
			Hum.AutoRotate = false
			M2("Off")
			UIS.MouseIconEnabled = false
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if Target and LockOn then
		local Mag = (HRP.Position - Target.Position).Magnitude
		if Mag < 50 then
			UIS.MouseBehavior = Enum.MouseBehavior.Default
			Cam.CFrame = CFrame.lookAt(Cam.CFrame.Position, Target.Position) * CFrame.new(2,0,0)
			local direction = (HRP.Position - Target.Position).Unit * Vector3.new(-1,0,-1)
			HRP.CFrame = CFrame.lookAt(HRP.Position, HRP.Position + direction)
		else
			LockOn = false
			Target = nil
			Hum.AutoRotate = true
			M2("On")
			UIS.MouseIconEnabled = true
		end
	end
end)