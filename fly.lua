--[[ 
    XENO RIVALS GOD HUB | ULTRA STABLE VERSION
    GitHub: OfficialMarcinoX
    Zasilane przez Rayfield Engine
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | OfficialMarcinoX HUB",
   LoadingTitle = "MARCINOX REVERSE SYSTEM",
   LoadingSubtitle = "Rivals Edition",
   ConfigurationSaving = { Enabled = false }
})

-- Zmienne systemowe
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Aimbot = false
_G.AutoShoot = false
_G.NoClip = false
_G.Fly = false
_G.ESP = false
_G.FlySpeed = 250

-- WSZYSTKO W JEDNEJ ZAKŁADCE RIVALS
local RivalsTab = Window:CreateTab("Rivals Cheats", 4483345998)

RivalsTab:CreateSection("Główne Funkcje")

RivalsTab:CreateToggle({
   Name = "SILENT AIMBOT (Namierzanie)",
   CurrentValue = false,
   Callback = function(Value) _G.Aimbot = Value end,
})

RivalsTab:CreateToggle({
   Name = "AUTO-SHOOT (Samo Strzela)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoShoot = Value end,
})

RivalsTab:CreateToggle({
   Name = "MEGA FLY (Klawisz F)",
   CurrentValue = false,
   Callback = function(Value) _G.Fly = Value end,
})

RivalsTab:CreateToggle({
   Name = "NOCLIP (Przez Ściany)",
   CurrentValue = false,
   Callback = function(Value) _G.NoClip = Value end,
})

RivalsTab:CreateToggle({
   Name = "ESP (Widzenie przez ściany)",
   CurrentValue = false,
   Callback = function(Value) _G.ESP = Value end,
})

RivalsTab:CreateSlider({
   Name = "Prędkość (Fly/Speed)",
   Min = 50,
   Max = 1000,
   CurrentValue = 250,
   Callback = function(Value) _G.FlySpeed = Value end,
})

-- ==========================================
-- LOGIKA WYMUSZANIA FUNKCJI (FORCE UPDATE)
-- ==========================================

RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart
    local Hum = Char:FindFirstChildOfClass("Humanoid")

    -- 1. FIX FLY (Teraz postać NIE SPADA)
    if _G.Fly then
        local Vel = Root:FindFirstChild("XenoVel") or Instance.new("BodyVelocity", Root)
        local Gyro = Root:FindFirstChild("XenoGyro") or Instance.new("BodyGyro", Root)
        
        Vel.Name = "XenoVel"
        Gyro.Name = "XenoGyro"
        
        Vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        Gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        Gyro.CFrame = Camera.CFrame
        
        local Dir = Vector3.new(0, 0.1, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Camera.CFrame.RightVector end
        
        Vel.Velocity = Dir * _G.FlySpeed
        if Hum then Hum.PlatformStand = true end
    else
        if Root:FindFirstChild("XenoVel") then Root.XenoVel:Destroy() end
        if Root:FindFirstChild("XenoGyro") then Root.XenoGyro:Destroy() end
        if Hum then Hum.PlatformStand = false end
    end

    -- 2. FIX AIMBOT (Hard Lock)
    if _G.Aimbot then
        local Target = nil
        local Dist = 2000
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local Pos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if OnScreen then
                    local Mag = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if Mag < Dist then Dist = Mag; Target = p.Character.Head end
                end
            end
        end
        if Target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
            -- Auto-Shoot (jeśli włączony)
            if _G.AutoShoot then
                mouse1press(); task.wait(0.01); mouse1release()
            end
        end
    end

    -- 3. ESP (Proste podświetlanie graczy)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local Highlight = p.Character:FindFirstChild("XenoESP")
            if _G.ESP then
                if not Highlight then
                    Highlight = Instance.new("Highlight", p.Character)
                    Highlight.Name = "XenoESP"
                    Highlight.FillColor = p.Team == LocalPlayer.Team and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
                end
            else
                if Highlight then Highlight:Destroy() end
            end
        end
    end
end)

-- 4. FIX NOCLIP (Teraz działa na 100% w Xeno)
RunService.Stepped:Connect(function()
    if _G.NoClip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- BIND F (Toggle Fly)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        _G.Fly = not _G.Fly
        Rayfield:Notify({Title = "Movement", Content = "Mega Fly: " .. tostring(_G.Fly), Duration = 1})
    end
end)
