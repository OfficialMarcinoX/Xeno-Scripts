-- [[ RIVALS SUPREMACY V6 - MEGA RAGE ENGINE ]]
-- Lines: Rozbudowany do stabilnej pracy w Xeno
-- Features: HackBucks Multi-Engine, Ultra Fly, ESP, Custom Hitboxes

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos Engine | Ultra Destructor",
   LoadingTitle = "Inicjalizacja Systemów Destrukcji...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // BEZPIECZNE USŁUGI (Fix dla błędu z konsoli) // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // GLOBALNY SYSTEM USTAWIEŃ // --
getgenv().Settings = {
    -- State
    HackBucks = false,
    -- Movement
    UltraFly = false,
    FlySpeed = 300,
    InfJump = false,
    SpeedHack = false,
    WalkSpeedValue = 150,
    -- Combat Logic
    HitboxSize = 10,
    Smoothing = 0.5,
    AutoShoot = false,
    SilentAim = false,
    -- Visuals
    FullBright = false,
    EspEnabled = false
}

-- // MODUŁ SZUKANIA CELU // --
local function getClosestEnemy()
    local target, dist = nil, math.huge
    local allP = Players:GetPlayers()
    
    for i = 1, #allP do
        local v = allP[i]
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
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

-- // --- TWORZENIE GUI (ROZBUDOWANE) --- // --

local RageTab = Window:CreateTab("🔥 RAGE", 4483362458)
local MoveTab = Window:CreateTab("🚀 MOVEMENT", 4483362458)
local VisualsTab = Window:CreateTab("👁️ VISUALS", 4483362458)
local CreditsTab = Window:CreateTab("📜 CREDITS", 4483362458)

-- // ZAKŁADKA RAGE // --

RageTab:CreateSection("Główny Silnik")

RageTab:CreateToggle({
   Name = "ACTIVATE HACKBUCKS (ALL MODES)",
   CurrentValue = false,
   Callback = function(Value)
      getgenv().Settings.HackBucks = Value
      if Value then
          -- HackBucks automatycznie odpala inne tryby do testowania AC
          getgenv().Settings.UltraFly = true
          getgenv().Settings.AutoShoot = true
          getgenv().Settings.SilentAim = true
          getgenv().Settings.EspEnabled = true
          Rayfield:Notify({Title = "HACKBUCKS ON", Content = "Aktywowano: Fly, Aim, Shoot, ESP. (REJOIN POMINIĘTY)"})
      else
          getgenv().Settings.UltraFly = false
          getgenv().Settings.AutoShoot = false
      end
   end,
})

RageTab:CreateSlider({
   Name = "Hitbox Expander",
   Range = {2, 50},
   Increment = 1,
   CurrentValue = 10,
   Callback = function(Value) getgenv().Settings.HitboxSize = Value end,
})

RageTab:CreateSlider({
   Name = "TP Smoothing (Anti-Kick)",
   Range = {0.1, 1},
   Increment = 0.1,
   CurrentValue = 0.5,
   Callback = function(Value) getgenv().Settings.Smoothing = Value end,
})

-- // ZAKŁADKA MOVEMENT // --

MoveTab:CreateSection("Ustawienia Ruchu")

MoveTab:CreateToggle({
   Name = "Ultra Fly (CFrame Mode)",
   CurrentValue = false,
   Callback = function(Value) getgenv().Settings.UltraFly = Value end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed Multiplier",
   Range = {50, 2000},
   Increment = 50,
   CurrentValue = 300,
   Callback = function(Value) getgenv().Settings.FlySpeed = Value end,
})

MoveTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value) getgenv().Settings.InfJump = Value end,
})

-- // ZAKŁADKA VISUALS // --

VisualsTab:CreateToggle({
   Name = "Player Highlights (Chams)",
   CurrentValue = false,
   Callback = function(Value) getgenv().Settings.EspEnabled = Value end,
})

VisualsTab:CreateToggle({
   Name = "Full Bright Mode",
   CurrentValue = false,
   Callback = function(Value) getgenv().Settings.FullBright = Value end,
})

-- // --- GŁÓWNA PĘTLA WYKONAWCZA (SILNIK) --- // --

RunService.RenderStepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = LP.Character.HumanoidRootPart
    local hum = LP.Character:FindFirstChildOfClass("Humanoid")
    
    -- LOGIKA: HACKBUCKS (COMBO)
    if getgenv().Settings.HackBucks then
        local target = getClosestEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            -- 1. Płynny Teleport do wroga
            local goal = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 5)
            hrp.CFrame = hrp.CFrame:Lerp(goal, getgenv().Settings.Smoothing)
            
            -- 2. Aim Lock
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            
            -- 3. Hitbox Expander (Bliski dystans)
            if (target.Character.Head.Position - hrp.Position).Magnitude < 30 then
                target.Character.Head.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
                target.Character.Head.CanCollide = false
            end
            
            -- 4. Auto Shoot (Virtual Input)
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.01)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end
    
    -- LOGIKA: ULTRA FLY
    if getgenv().Settings.UltraFly and not getgenv().Settings.HackBucks then
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Settings.FlySpeed / 100))
        if hum then hum.PlatformStand = true end
    elseif hum and not getgenv().Settings.HackBucks then
        hum.PlatformStand = false
    end
    
    -- LOGIKA: FULL BRIGHT
    if getgenv().Settings.FullBright then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 14
    end
end)

-- // MODUŁ: ESP & CHAMS // --
task.spawn(function()
    while task.wait(1) do
        if getgenv().Settings.EspEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", p.Character)
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end
end)

-- // MODUŁ: INF JUMP // --
UIS.JumpRequest:Connect(function()
    if getgenv().Settings.InfJump and LP.Character then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

CreditsTab:CreateLabel("Script developed for Rivals AC Testing")
CreditsTab:CreateLabel("Owner: planexd_0")

Rayfield:Notify({Title = "V6 LOADED", Content = "HackBucks gotowy. Rejoin wyłączony!", Duration = 5})
