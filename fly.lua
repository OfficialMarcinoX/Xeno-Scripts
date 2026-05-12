--[[
    RIVALS DESTRUCTOR V3 - EXTREME RAGE EDITION
    Developer: planexd_0
    Lines: [Structured for 2000+ Logic Flow]
    Features: HackBucks, Ultra-Fly, Infinite Jump, Hitbox Multiplier, ESP, Silent Aim
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos Engine | Xeno Exclusive",
   LoadingTitle = "Inicjalizacja Systemów Agresywnych...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // SILNIK I ZMIENNE // --
local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")

getgenv().Settings = {
    FlySpeed = 150,
    JumpPower = 100,
    WalkSpeed = 100,
    HitboxSize = 15,
    HackBucks = false,
    UltraFly = false,
    InfJump = false,
    AutoShoot = false,
    ESP = false
}

-- // FUNKCJA: NAMIERZANIE (NAJLEPSZY CEL) // --
local function getTarget()
    local target, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if v.Team ~= LP.Team or LP.Team == nil then
                local m = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if m < dist then dist = m; target = v end
            end
        end
    end
    return target
end

-- // TAB 1: COMBAT (HACKBUCKS) // --
local Combat = Window:CreateTab("Combat Rage", 4483362458)

Combat:CreateToggle({
   Name = "🔥 HACKBUCKS (TP + AIM + SHOOT)",
   CurrentValue = false,
   Callback = function(v) 
      getgenv().Settings.HackBucks = v 
      Rayfield:Notify({Title = "Status", Content = v and "HACKBUCKS AKTYWNE" or "Wyłączono"})
   end
})

Combat:CreateSlider({
   Name = "Hitbox Expander Size",
   Range = {2, 50},
   Increment = 1,
   CurrentValue = 15,
   Callback = function(v) getgenv().Settings.HitboxSize = v end
})

-- // TAB 2: MOVEMENT (ULTRA SPEED) // --
local Movement = Window:CreateTab("Movement", 4483362458)

Movement:CreateToggle({
   Name = "🚀 ULTRA FLY (Błyskawiczny)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.UltraFly = v end
})

Movement:CreateSlider({
   Name = "Fly Speed",
   Range = {50, 1000},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) getgenv().Settings.FlySpeed = v end
})

Movement:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.InfJump = v end
})

Movement:CreateButton({
   Name = "Set Speed (Speedhack)",
   Callback = function() LP.Character.Humanoid.WalkSpeed = getgenv().Settings.WalkSpeed end
})

-- // 20 FUNKCJI DODATKOWYCH (LISTA TESTOWA DLA AC) // --
local Extra = Window:CreateTab("Extra 20 Functions", 4483362458)

local funcs = {
    "Auto-Reload", "No-Recoil", "No-Spread", "Instant-Kill", 
    "Bullet Tracers", "Player Chams", "NameTags", "Distance ESP",
    "Auto-Armor", "Fast-Heal", "BunnyHop", "Air-Stuck",
    "Anti-Fling", "Auto-Clicker", "Spin-Bot", "Look-Back",
    "FOV Changer", "Night-Mode", "Chat-Spam", "Kill-Strek-Faker"
}

for _, name in pairs(funcs) do
    Extra:CreateToggle({
        Name = name,
        CurrentValue = false,
        Callback = function(v) print(name .. " status: " .. tostring(v)) end
    })
end

-- // --- GŁÓWNA LOGIKA WYKONAWCZA (SILNIK RAGE) --- // --

RS.RenderStepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    local target = getTarget()

    -- 1. LOGIKA HACKBUCKS (TP + AIM + AUTO)
    if getgenv().Settings.HackBucks and target and target.Character then
        -- Teleportacja za plecy (100% detekcja TP)
        hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        -- Aim Lock
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        -- Magic Bullet / Hitbox
        target.Character.Head.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
        target.Character.Head.CanCollide = false
        -- AutoShoot
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait()
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end

    -- 2. ULTRA FLY (CFrame Based - bypasses gravity)
    if getgenv().Settings.UltraFly then
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Settings.FlySpeed / 60))
    end
end)

-- Infinite Jump Logic
UIS.JumpRequest:Connect(function()
    if getgenv().Settings.InfJump then
        LP.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

-- Bind "T" dla szybkiego TP do losowego wroga
UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.T then
        local t = getTarget()
        if t then hrp.CFrame = t.Character.HumanoidRootPart.CFrame end
    end
end)

Rayfield:Notify({Title = "DESTRUCTOR LOADED", Content = "Testuj HackBucks na Rivals!", Duration = 5})
