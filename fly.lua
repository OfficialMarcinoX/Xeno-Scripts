--[[ 
    Rivals Multi-Hack GUI for Xeno 
    Features: Aimbot, Mega Fly (F), NoClip, TP, Speed
    Library: Orion Lib
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Rivals Hub | Xeno Edition", HidePremium = false, SaveConfig = true, ConfigFolder = "XenoRivals"})

-- Zmienne
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ustawienia
_G.AimbotEnabled = false
_G.NoClipEnabled = false
_G.FlyEnabled = false
_G.WalkSpeed = 16
local FlySpeed = 250 -- Prędkość MEGA Fly

-- ==========================================
-- TAB: COMBAT (Aimbot)
-- ==========================================
local CombatTab = Window:MakeTab({Name = "Combat", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddToggle({
	Name = "Aimbot",
	Default = false,
	Callback = function(Value)
		_G.AimbotEnabled = Value
	end    
})

RunService.RenderStepped:Connect(function()
    if _G.AimbotEnabled then
        local ClosestPlayer = nil
        local ShortestDistance = math.huge

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Team ~= LocalPlayer.Team then
                local ScreenPos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                    if Distance < ShortestDistance then
                        ClosestPlayer = v
                        ShortestDistance = Distance
                    end
                end
            end
        end

        if ClosestPlayer then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, ClosestPlayer.Character.HumanoidRootPart.Position)
        end
    end
end)

-- ==========================================
-- TAB: MOVEMENT (Fly, NoClip, Speed)
-- ==========================================
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458", PremiumOnly = false})

-- Logika Latania
local BodyGyro, BodyVelocity

local function StartFly()
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Root = Character.HumanoidRootPart
    
    BodyGyro = Instance.new("BodyGyro", Root)
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = Root.CFrame
    
    BodyVelocity = Instance.new("BodyVelocity", Root)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    Character.Humanoid.PlatformStand = true
    
    task.spawn(function()
        while _G.FlyEnabled and Character:FindFirstChild("HumanoidRootPart") do
            local Direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction = Direction + Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction = Direction - Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction = Direction - Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction = Direction + Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direction = Direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direction = Direction - Vector3.new(0, 1, 0) end
            
            BodyVelocity.Velocity = Direction * FlySpeed
            BodyGyro.CFrame = Camera.CFrame
            RunService.RenderStepped:Wait()
        end
    end)
end

local function StopFly()
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

-- Włączanie/Wyłączanie latania pod przyciskiem F
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end -- ignoruje kliknięcia w chat itp.
    if input.KeyCode == Enum.KeyCode.F then
        _G.FlyEnabled = not _G.FlyEnabled
        if _G.FlyEnabled then
            StartFly()
            OrionLib:MakeNotification({Name = "Fly", Content = "Latanie Włączone (MEGA)", Time = 2})
        else
            StopFly()
            OrionLib:MakeNotification({Name = "Fly", Content = "Latanie Wyłączone", Time = 2})
        end
    end
end)

MoveTab:AddToggle({
	Name = "Mega Fly (Włącz z GUI lub użyj klawisza F)",
	Default = false,
	Callback = function(Value)
		_G.FlyEnabled = Value
        if _G.FlyEnabled then StartFly() else StopFly() end
	end    
})

MoveTab:AddSlider({
	Name = "WalkSpeed",
	Min = 16,
	Max = 200,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "Speed",
	Callback = function(Value)
		LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end    
})

MoveTab:AddToggle({
	Name = "NoClip (Przechodzenie przez ściany)",
	Default = false,
	Callback = function(Value)
		_G.NoClipEnabled = Value
	end    
})

RunService.Stepped:Connect(function()
    if _G.NoClipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ==========================================
-- TAB: TELEPORT
-- ==========================================
local TPTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998", PremiumOnly = false})

local function GetPlayerList()
    local Names = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then table.insert(Names, v.Name) end
    end
    return Names
end

TPTab:AddDropdown({
	Name = "Wybierz Gracza",
	Default = "",
	Options = GetPlayerList(),
	Callback = function(Value)
		local Target = Players:FindFirstChild(Value)
		if Target and Target.Character and Target.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame
		end
	end    
})

OrionLib:Init()
