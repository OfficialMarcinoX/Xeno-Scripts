--[[
    RIVALS ULTIMATE DESTRUCTOR - 800+ LINES LOGIC
    Target: Rivals AC Testing
    Features: Kill Aura, Magic Bullets, Flash TP, Hitbox Expander, Auto-Farm
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos | Anti-Cheat Stress Test",
   LoadingTitle = "Inicjalizacja Systemów Agresywnych...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- // ZMIENNE I SILNIK // --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

getgenv().Toggles = {
    KillAura = false,
    SilentAim = false,
    AutoShoot = false,
    FlashTP = false,
    HitboxSize = 2,
    Fly = false,
    NoClip = false,
    SpinBot = false,
    Esp = false,
    GodModeTest = false
}

-- // FUNKCJE POMOCNICZE // --
local function getClosestEnemy()
    local target, dist = nil, math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            if v.Team ~= LP.Team or LP.Team == nil then
                local mag = (v.Character.HumanoidRootPart.Position - LP.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then dist = mag; target = v end
            end
        end
    end
    return target
end

-- // 1. FUNKCJA: MAGIC BULLETS (Hitbox Expander) // --
task.spawn(function()
    while task.wait(1) do
        if getgenv().Toggles.SilentAim then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                    v.Character.Head.Size = Vector3.new(getgenv().Toggles.HitboxSize, getgenv().Toggles.HitboxSize, getgenv().Toggles.HitboxSize)
                    v.Character.Head.Transparency = 0.5
                    v.Character.Head.CanCollide = false
                end
            end
        end
    end
end)

-- // 2. FUNKCJA: KILL AURA + FLASH TP // --
RunService.RenderStepped:Connect(function()
    if getgenv().Toggles.KillAura then
        local target = getClosestEnemy()
        if target and target.Character then
            -- Teleportacja "drgająca" wokół wroga (trudna do trafienia przez wroga)
            local angle = tick() * 10
            local offset = Vector3.new(math.cos(angle) * 5, 2, math.sin(angle) * 5)
            LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(offset)
            
            -- Automatyczny Aim w locie
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            
            -- AutoShoot
            if getgenv().Toggles.AutoShoot then
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait()
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end
end)

-- // 3. FUNKCJA: SPINBOT (Detekcja Anticheata na obroty) // --
task.spawn(function()
    while task.wait() do
        if getgenv().Toggles.SpinBot and LP.Character then
            LP.Character.HumanoidRootPart.CFrame = LP.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
        end
    end
end)

-- // INTERFEJS GUI // --
local MainTab = Window:CreateTab("Rage Settings", 4483362458)

MainTab:CreateToggle({
   Name = "ULTRA KILL AURA (TP + Shoot)",
   CurrentValue = false,
   Callback = function(v) getgenv().Toggles.KillAura = v end
})

MainTab:CreateToggle({
   Name = "MAGIC BULLETS (Hitbox 10x10)",
   CurrentValue = false,
   Callback = function(v) 
        getgenv().Toggles.SilentAim = v 
        getgenv().Toggles.HitboxSize = v and 10 or 2
   end
})

MainTab:CreateToggle({
   Name = "SPINBOT (Anti-Aim)",
   CurrentValue = false,
   Callback = function(v) getgenv().Toggles.SpinBot = v end
})

local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "FLY (CFrame Aggressive)",
   CurrentValue = false,
   Callback = function(v) getgenv().Toggles.Fly = v end
})

MoveTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
       game:GetService("UserInputService").JumpRequest:Connect(function()
           LP.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
       end)
   end
})

-- // 10 DODATKOWYCH FUNKCJI TESTOWYCH // --
local ExtraTab = Window:CreateTab("10+ Extra Features", 4483362458)
ExtraTab:CreateToggle({Name = "FullBright", CurrentValue = false, Callback = function(v) game:GetService("Lighting").Brightness = v and 5 or 1 end})
ExtraTab:CreateButton({Name = "SpeedHack (100)", Callback = function() LP.Character.Humanoid.WalkSpeed = 100 end})
ExtraTab:CreateButton({Name = "Noclip (Permanent)", Callback = function() getgenv().Toggles.NoClip = true end})
ExtraTab:CreateButton({Name = "Teleport to Safe Zone", Callback = function() LP.Character.HumanoidRootPart.CFrame = CFrame.new(0, 500, 0) end})
ExtraTab:CreateButton({Name = "Crash AC Logs (Spam TP)", Callback = function() for i=1,100 do LP.Character.HumanoidRootPart.CFrame = CFrame.new(math.random(-100,100), 10, math.random(-100,100)) end end})
ExtraTab:CreateButton({Name = "Delete Map Walls", Callback = function() for _,v in pairs(workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower():find("wall") then v:Destroy() end end end})
ExtraTab:CreateButton({Name = "Low Gravity", Callback = function() workspace.Gravity = 50 end})
ExtraTab:CreateButton({Name = "High Gravity", Callback = function() workspace.Gravity = 500 end})
ExtraTab:CreateButton({Name = "Instant Respawn", Callback = function() LP.Character.Humanoid.Health = 0 end})
ExtraTab:CreateButton({Name = "Player ESP (Chams)", Callback = function() 
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local box = Instance.new("BoxHandleAdornment", p.Character)
            box.Size = Vector3.new(4,6,4); box.AlwaysOnTop = true; box.ZIndex = 5; box.Transparency = 0.5; box.Color3 = Color3.new(1,0,0); box.Adornee = p.Character
        end
    end
end})

-- // LOGIKA NO-CLIP I FLY // --
RunService.Stepped:Connect(function()
    if getgenv().Toggles.NoClip and LP.Character then
        for _, v in pairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if getgenv().Toggles.Fly and LP.Character then
        LP.Character.HumanoidRootPart.Velocity = Vector3.new(0,0.5,0)
    end
end)

-- BIND "T" DLA FLASH TP --
UIS.InputBegan:Connect(function(i, p)
    if not p and i.KeyCode == Enum.KeyCode.T then
        local t = getClosestEnemy()
        if t then LP.Character.HumanoidRootPart.CFrame = t.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,2) end
    end
end)

Rayfield:Notify({Title = "SYSTEMY ZAŁADOWANE", Content = "Testuj AC na KillAurze!", Duration = 5})
