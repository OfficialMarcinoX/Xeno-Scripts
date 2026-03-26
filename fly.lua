--[[ 
    Rivals Multi-Hack | Zoptymalizowane pod Xeno
    GitHub: OfficialMarcinoX
    Features: Aimbot, Mega Fly (F), NoClip, TP
]]

-- Ładowanie biblioteki z poprawką na czas oczekiwania
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Tworzenie Okna (Zapewnienie widoczności)
local Window = OrionLib:MakeWindow({
    Name = "Rivals Hub | Xeno Edition", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "XenoRivals",
    IntroEnabled = true,
    IntroText = "Wczytywanie Xeno Hub..."
})

-- Zmienne
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ustawienia globalne
_G.AimbotEnabled = false
_G.NoClipEnabled = false
_G.FlyEnabled = false
_G.FlySpeed = 250

-- ==========================================
-- ZAKŁADKA: RIVALS (Aimbot)
-- ==========================================
local CombatTab = Window:MakeTab({Name = "Rivals", Icon = "rbxassetid://4483345998", PremiumOnly = false})

CombatTab:AddToggle({
	Name = "Aimbot (Auto-Lock)",
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
-- ZAKŁADKA: MOVEMENT (Fly, NoClip)
-- ==========================================
local MoveTab = Window:MakeTab({Name = "Movement", Icon = "rbxassetid://4483362458", PremiumOnly = false})

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
            local CamCF = Camera.CFrame
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then Direction = Direction + CamCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then Direction = Direction - CamCF.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then Direction = Direction - CamCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then Direction = Direction + CamCF.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then Direction = Direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then Direction = Direction - Vector3.new(0, 1, 0) end
            
            BodyVelocity.Velocity = Direction * _G.FlySpeed
            BodyGyro.CFrame = CamCF
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

-- Obsługa klawisza F
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.F then
        _G.FlyEnabled = not _G.FlyEnabled
        if _G.FlyEnabled then StartFly() else StopFly() end
        OrionLib:MakeNotification({Name = "System", Content = "Fly: " .. tostring(_G.FlyEnabled), Time = 1})
    end
end)

MoveTab:AddToggle({
	Name = "Mega Fly (Klawisz F)",
	Default = false,
	Callback = function(Value)
		_G.FlyEnabled = Value
        if _G.FlyEnabled then StartFly() else StopFly() end
	end    
})

MoveTab:AddSlider({
	Name = "Prędkość Lotu",
	Min = 50,
	Max = 1000,
	Default = 250,
	Callback = function(Value) _G.FlySpeed = Value end    
})

MoveTab:AddToggle({
	Name = "NoClip (Przez ściany)",
	Default = false,
	Callback = function(Value) _G.NoClipEnabled = Value end    
})

RunService.Stepped:Connect(function()
    if _G.NoClipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Inicjalizacja końcowa
OrionLib:Init()
