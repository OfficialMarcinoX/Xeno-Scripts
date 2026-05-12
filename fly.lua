-- [[ RIVALS SUPREMACY V4 - EXTREME STRESS TEST ]]
-- Lines: 250+ | Status: FIXED & AGGRESSIVE

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos Engine | Ultra Edition",
   LoadingTitle = "Inicjalizacja Systemów Destrukcji...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // BEZPIECZNE USŁUGI (Naprawa błędu Players/DataModel) // --
local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // GLOBALNY CONFIG // --
getgenv().Settings = {
    -- Combat
    HackBucks = false,
    HitboxSize = 20,
    SilentAim = false,
    AutoShoot = false,
    NoRecoil = false,
    InstantReload = false,
    -- Movement
    UltraFly = false,
    FlySpeed = 250,
    InfJump = false,
    SpeedHack = false,
    WalkSpeedValue = 100,
    -- Visuals
    EspEnabled = false,
    FullBright = false,
    Tracers = false,
    -- Fun/Misc
    SpinBot = false,
    AntiAim = false
}

-- // FUNKCJE LOGICZNE // --

local function getTarget()
    local target, dist = nil, math.huge
    local pList = Players:GetPlayers()
    for _, v in pairs(pList) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                -- Sprawdzanie teamu
                if v.Team ~= LP.Team or LP.Team == nil then
                    local m = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                    if m < dist then 
                        dist = m
                        target = v 
                    end
                end
            end
        end
    end
    return target
end

-- // INTERFEJS GUI // --

local CombatTab = Window:CreateTab("🔥 Combat", 4483362458)
local MoveTab = Window:CreateTab("🚀 Movement", 4483362458)
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483362458)
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

-- COMBAT SECTION
CombatTab:CreateToggle({
   Name = "HACKBUCKS (TP + AIM + AUTO)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.HackBucks = v end
})

CombatTab:CreateSlider({
   Name = "Hitbox Multiplier",
   Range = {2, 150},
   Increment = 1,
   CurrentValue = 20,
   Callback = function(v) getgenv().Settings.HitboxSize = v end
})

CombatTab:CreateToggle({
   Name = "No Recoil / Spread",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.NoRecoil = v end
})

CombatTab:CreateToggle({
   Name = "Instant Reload",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.InstantReload = v end
})

-- MOVEMENT SECTION
MoveTab:CreateToggle({
   Name = "ULTRA FLY (CFrame)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.UltraFly = v end
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {50, 3000},
   Increment = 50,
   CurrentValue = 250,
   Callback = function(v) getgenv().Settings.FlySpeed = v end
})

MoveTab:CreateToggle({
   Name = "SpeedHack (Active)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.SpeedHack = v end
})

MoveTab:CreateSlider({
   Name = "WalkSpeed Value",
   Range = {16, 500},
   Increment = 5,
   CurrentValue = 100,
   Callback = function(v) getgenv().Settings.WalkSpeedValue = v end
})

MoveTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.InfJump = v end
})

-- VISUALS SECTION
VisualsTab:CreateToggle({
   Name = "Player ESP (Chams)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.EspEnabled = v end
})

VisualsTab:CreateToggle({
   Name = "FullBright (No Shadows)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.FullBright = v end
})

-- MISC SECTION
MiscTab:CreateToggle({
   Name = "SpinBot (Rage Anti-Aim)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.SpinBot = v end
})

MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
       game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
   end
})

-- // GŁÓWNA PĘTLA SILNIKA (EXECUTOR) // --

RS.RenderStepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local hum = LP.Character:FindFirstChildOfClass("Humanoid")

    -- 1. MODUŁ HACKBUCKS
    if getgenv().Settings.HackBucks then
        local target = getTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- Teleportacja
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
            -- Aim
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            -- Hitbox
            target.Character.Head.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
            target.Character.Head.CanCollide = false
            -- Shooting
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.01)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end

    -- 2. MODUŁ ULTRA FLY
    if getgenv().Settings.UltraFly then
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Settings.FlySpeed / 100))
        hum.PlatformStand = true
    else
        if hum.PlatformStand then hum.PlatformStand = false end
    end

    -- 3. MODUŁ SPEEDHACK
    if getgenv().Settings.SpeedHack and hum then
        hum.WalkSpeed = getgenv().Settings.WalkSpeedValue
    end

    -- 4. MODUŁ SPINBOT
    if getgenv().Settings.SpinBot then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
    
    -- 5. MODUŁ FULLBRIGHT
    if getgenv().Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
    end
end)

-- // MODUŁ INFINITE JUMP // --
UIS.JumpRequest:Connect(function()
    if getgenv().Settings.InfJump and LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- // MODUŁ ESP (CHAMS) // --
task.spawn(function()
    while task.wait(2) do
        if getgenv().Settings.EspEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("Highlight") then
                    local highlight = Instance.new("Highlight")
                    highlight.Parent = p.Character
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end)

Rayfield:Notify({
   Title = "Xeno Destructor v4 Loaded",
   Content = "Gotowy do testowania Twojego Anticheata!",
   Duration = 5
})
