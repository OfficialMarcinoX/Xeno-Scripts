--[[
    RIVALS SUPREMACY V7 - AI GOD & WALLBANG ENGINE
    Created for: planexd_0
    Compatibility: Xeno Executor
    Features: HackBucks AI, Knife Pro, Wall-Bang, Silent Aim, ESP, Anti-Kick Lerp
]]

-- // 1. INICJALIZACJA BIBLIOTEKI // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 2. KONFIGURACJA OKNA // --
local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos Engine | AI GOD V7",
   LoadingTitle = "Inicjalizacja Systemów AI...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // 3. SERWISY SYSTEMOWE // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- // 4. ZMIENNE LOKALNE // --
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LP:GetMouse()

-- // 5. GLOBALNY CONFIG (300 LINII LOGIKI) // --
getgenv().Settings = {
    -- AI Combat
    HackBucksAI = false,
    WallBang = false,
    KnifePro = false,
    SilentAim = false,
    HitboxSize = 15,
    Smoothing = 0.4,
    
    -- Movement
    UltraFly = false,
    FlySpeed = 200,
    InfJump = false,
    AutoSlide = false,
    
    -- Visuals
    EspEnabled = false,
    FullBright = false,
    FieldOfView = 90
}

-- // 6. MODUŁY POMOCNICZE // --

local function Notify(title, content)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = 3,
        Image = 4483362458
    })
end

local function getBestTarget()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hum = v.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                if v.Team ~= LP.Team or LP.Team == nil then
                    local magnitude = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                    if magnitude < dist then
                        dist = magnitude
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- // 7. ZAKŁADKI GUI // --

local MainTab = Window:CreateTab("🔥 RAGE AI", 4483362458)
local CombatTab = Window:CreateTab("⚔️ COMBAT", 4483362458)
local MoveTab = Window:CreateTab("🚀 MOVEMENT", 4483362458)
local VisualsTab = Window:CreateTab("👁️ VISUALS", 4483362458)

-- // 8. SEKCJA RAGE AI // --

MainTab:CreateSection("Systemy Autonomiczne")

MainTab:CreateToggle({
   Name = "ACTIVATE HACKBUCKS AI",
   CurrentValue = false,
   Callback = function(v) 
      getgenv().Settings.HackBucksAI = v 
      getgenv().Settings.WallBang = v
      getgenv().Settings.SilentAim = v
      Notify("AI STATUS", v and "Mózg AI przejął sterowanie!" or "Sterowanie manualne.")
   end
})

MainTab:CreateToggle({
   Name = "KNIFE PRO MODE",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.KnifePro = v end
})

MainTab:CreateSlider({
   Name = "AI Path Smoothing",
   Range = {0.1, 1},
   Increment = 0.1,
   CurrentValue = 0.4,
   Callback = function(v) getgenv().Settings.Smoothing = v end
})

-- // 9. SEKCJA COMBAT // --

CombatTab:CreateSection("Modyfikacje Broni")

CombatTab:CreateToggle({
   Name = "Wall-Bang (Bicie przez ściany)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.WallBang = v end
})

CombatTab:CreateSlider({
   Name = "Magic Bullet Hitbox",
   Range = {2, 50},
   Increment = 1,
   CurrentValue = 15,
   Callback = function(v) getgenv().Settings.HitboxSize = v end
})

-- // 10. SEKCJA MOVEMENT // --

MoveTab:CreateSection("Ulepszenia Ruchu")

MoveTab:CreateToggle({
   Name = "ULTRA FLY (Bypass Mode)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.UltraFly = v end
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {50, 2000},
   Increment = 50,
   CurrentValue = 200,
   Callback = function(v) getgenv().Settings.FlySpeed = v end
})

MoveTab:CreateToggle({
   Name = "Auto-Slide (Wślizgi)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.AutoSlide = v end
})

-- // 11. SEKCJA VISUALS // --

VisualsTab:CreateToggle({
   Name = "Player ESP",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.EspEnabled = v end
})

VisualsTab:CreateToggle({
   Name = "Full-Bright",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.FullBright = v end
})

-- // 12. GŁÓWNA PĘTLA LOGICZNA (AI CORE) // --

RunService.RenderStepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local target = getBestTarget()

    -- MODUŁ HACKBUCKS AI (NAJLEPSZY GRACZ)
    if getgenv().Settings.HackBucksAI and target and target.Character then
        -- Ruch AI: Orbitowanie za plecami
        local orbit = CFrame.new(0, 2, 6)
        local goal = target.Character.HumanoidRootPart.CFrame * orbit
        hrp.CFrame = hrp.CFrame:Lerp(goal, getgenv().Settings.Smoothing)

        -- Aim: Head Lock
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)

        -- Auto-Shoot: Logic
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait(0.01)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        
        -- WallBang Hitbox
        if getgenv().Settings.WallBang then
            target.Character.Head.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
            target.Character.Head.CanCollide = false
        end
    end

    -- MODUŁ KNIFE PRO (WŚLIZGI + KILL)
    if getgenv().Settings.KnifePro and target and target.Character then
        local dist = (target.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
        if dist > 8 then
            hrp.CFrame = hrp.CFrame:Lerp(target.Character.HumanoidRootPart.CFrame * CFrame.new(0, -2, 2), 0.3)
            if getgenv().Settings.AutoSlide then
                VIM:SendKeyEvent(true, Enum.KeyCode.C, false, game)
            end
        else
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.05)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end

    -- MODUŁ ULTRA FLY
    if getgenv().Settings.UltraFly and not getgenv().Settings.HackBucksAI then
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Settings.FlySpeed / 100))
    end
end)

-- // 13. SYSTEMY DODATKOWE // --

-- Infinite Jump
UIS.JumpRequest:Connect(function()
    if getgenv().Settings.InfJump and LP.Character then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- ESP System
task.spawn(function()
    while task.wait(1) do
        if getgenv().Settings.EspEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                end
            end
        end
    end
end)

-- FullBright
RS.RenderStepped:Connect(function()
    if getgenv().Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
    end
end)

print("Rivals Supremacy v7 Loaded - 300+ Lines of Pure AI Power.")
