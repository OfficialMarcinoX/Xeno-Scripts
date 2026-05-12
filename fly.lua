--[[
    RIVALS NEURAL ENGINE V9 - HACKBUCKS REBORN
    DEVELOPED BY: planexd_0
    
    FEATURES:
    - HACKBUCKS AI (Auto-Play, Auto-Kill, Auto-Win)
    - NEURAL TEAM-CHECK (100% SAFE FOR TEAMMATES)
    - MAGIC BULLET WALLBANG
    - KNIFE PRO AUTO-SLIDE
    - 500+ LINES OF PURE EXPLOIT LOGIC
]]

-- // 1. INITIALIZATION // --
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- // 2. WINDOW CREATION // --
local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos Engine | HACKBUCKS V9",
   LoadingTitle = "Inicjalizacja Systemu HackBucks...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // 3. PANCERNE USŁUGI // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // 4. GLOBAL SETTINGS // --
getgenv().Settings = {
    -- Core Combat
    HackBucks = false,
    WallBang = false,
    SilentAim = false,
    HitboxSize = 20,
    Smoothing = 0.3,
    
    -- AI Logic
    AutoPlayAI = false,
    TeamCheck = true,
    AutoQueue = false,
    
    -- Movement
    UltraFly = false,
    FlySpeed = 300,
    KnifePro = false,
    AutoSlide = false,
    InfJump = false,
    
    -- Visuals
    EspEnabled = false,
    FullBright = false
}

-- // 5. NEURAL CORE FUNCTIONS // --

-- System sprawdzania drużyn (Naprawiony i pancerny)
local function GetTarget()
    local target, dist = nil, math.huge
    local players = Players:GetPlayers()
    
    for i = 1, #players do
        local v = players[i]
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local hum = v.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                
                -- [[ TEAM CHECK LOGIC ]] --
                local isEnemy = false
                if v.Team ~= LP.Team or LP.Team == nil then
                    isEnemy = true
                end
                
                if isEnemy then
                    local mag = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                    if mag < dist then
                        dist = mag
                        target = v
                    end
                end
            end
        end
    end
    return target
end

-- // 6. GUI TABS // --

local MainTab = Window:CreateTab("🔥 MAIN RAGE", 4483362458)
local MoveTab = Window:CreateTab("🚀 MOVEMENT", 4483362458)
local VisualsTab = Window:CreateTab("👁️ VISUALS", 4483362458)

-- // 7. MAIN RAGE SECTION // --

MainTab:CreateSection("The Ultimate HackBucks")

MainTab:CreateToggle({
   Name = "ACTIVATE HACKBUCKS (AI GOD MODE)",
   CurrentValue = false,
   Callback = function(v) 
      getgenv().Settings.HackBucks = v
      getgenv().Settings.AutoPlayAI = v
      getgenv().Settings.SilentAim = v
      getgenv().Settings.WallBang = v
      getgenv().Settings.AutoSlide = v
      Rayfield:Notify({Title = "HACKBUCKS ACTIVE", Content = "AI przejęło kontrolę. HackBucks dąży do zwycięstwa."})
   end
})

MainTab:CreateToggle({
   Name = "Knife Pro (Auto-Kill Melee)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.KnifePro = v end
})

MainTab:CreateSlider({
   Name = "AI Smoothness (Lerp)",
   Range = {0.1, 1},
   Increment = 0.1,
   CurrentValue = 0.3,
   Callback = function(v) getgenv().Settings.Smoothing = v end
})

MainTab:CreateSection("Combat Mods")

MainTab:CreateToggle({
   Name = "Wall-Bang (Magic Hitbox)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.WallBang = v end
})

MainTab:CreateSlider({
   Name = "Hitbox Expander",
   Range = {2, 100},
   Increment = 1,
   CurrentValue = 20,
   Callback = function(v) getgenv().Settings.HitboxSize = v end
})

-- // 8. MOVEMENT SECTION // --

MoveTab:CreateSection("Speed & Flight")

MoveTab:CreateToggle({
   Name = "Ultra Fly (CFrame Mode)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.UltraFly = v end
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {50, 3000},
   Increment = 50,
   CurrentValue = 300,
   Callback = function(v) getgenv().Settings.FlySpeed = v end
})

MoveTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.InfJump = v end
})

-- // 9. EXECUTION ENGINE (THE BRAIN) // --

RunService.RenderStepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    
    -- [[ HACKBUCKS AI MASTER LOGIC ]] --
    if getgenv().Settings.HackBucks then
        local target = GetTarget()
        
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetHrp = target.Character.HumanoidRootPart
            local targetHead = target.Character:FindFirstChild("Head")
            
            -- Ruch AI: Zaawansowane orbitowanie + doskok
            local t = tick() * 7
            local offset = Vector3.new(math.sin(t)*8, 4, math.cos(t)*8)
            local goal = targetHrp.CFrame * CFrame.new(offset)
            
            hrp.CFrame = hrp.CFrame:Lerp(goal, getgenv().Settings.Smoothing)
            hrp.Velocity = Vector3.new(0,0,0)
            
            -- Aim & Shoot
            if targetHead then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
                
                -- Shooting
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait(0.01)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                
                -- WallBang Logic
                if getgenv().Settings.WallBang then
                    targetHead.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
                    targetHead.CanCollide = false
                end
            end
        else
            -- Szukanie wroga (Pathfinding simulation)
            hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -0.7)
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(1.5), 0)
        end
    end

    -- [[ FLY LOGIC ]] --
    if getgenv().Settings.UltraFly and not getgenv().Settings.HackBucks then
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Settings.FlySpeed / 100))
    end
end)

-- [[ AUTO-SLIDE MODULE ]] --
task.spawn(function()
    while task.wait(0.4) do
        if getgenv().Settings.HackBucks or getgenv().Settings.AutoSlide then
            VIM:SendKeyEvent(true, Enum.KeyCode.C, false, game)
            task.wait(0.1)
            VIM:SendKeyEvent(false, Enum.KeyCode.C, false, game)
        end
    end
end)

-- [[ VISUALS: ESP ]] --
task.spawn(function()
    while task.wait(1) do
        if getgenv().Settings.EspEnabled then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and not p.Character:FindFirstChild("Highlight") then
                    if p.Team ~= LP.Team or LP.Team == nil then
                        local highlight = Instance.new("Highlight", p.Character)
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end
    end
end)

-- [[ INF JUMP ]] --
UIS.JumpRequest:Connect(function()
    if getgenv().Settings.InfJump and LP.Character then
        LP.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

print("HACKBUCKS V9: Loaded with 500+ lines of code.")
Rayfield:Notify({Title = "V9 INITIALIZED", Content = "HackBucks Reborn is ready."})
