--[[
    RIVALS / ROBLOX ULTIMATE AC TESTER (RAGE EDITION)
    Features: 
    - Fly (Advanced Velocity)
    - Rage Aimbot (Camera Lock)
    - AutoShoot (Virtual Input)
    - Team-Based Teleport (Keybind: T)
    - NoClip & Speedhack
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno Destroyer v2 | AC TEST",
   LoadingTitle = "Ładowanie Modułów Destrukcji...",
   LoadingSubtitle = "By planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- Zmienne systemowe
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Config = {
    Fly = false,
    FlySpeed = 50,
    Aimbot = false,
    AutoShoot = false,
    NoClip = false,
    WalkSpeed = 16
}

-- FUNKCJA: Znajdź wroga (Inny Team)
local function getEnemy()
    local target = nil
    local dist = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            -- Sprawdzanie drużyny (jeśli gra posiada Teamy)
            if v.Team ~= LocalPlayer.Team or LocalPlayer.Team == nil then
                local mag = (v.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

-- TAB: COMBAT
local CombatTab = Window:CreateTab("Combat", 4483362458)

CombatTab:CreateToggle({
   Name = "Rage Aimbot (Direct CFrame Lock)",
   CurrentValue = false,
   Callback = function(Value)
      Config.Aimbot = Value
   end,
})

CombatTab:CreateToggle({
   Name = "AutoShoot (Triggerbot)",
   CurrentValue = false,
   Callback = function(Value)
      Config.AutoShoot = Value
   end,
})

-- TAB: MOVEMENT
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "Enable Fly",
   CurrentValue = false,
   Callback = function(Value)
      Config.Fly = Value
   end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {16, 500},
   Increment = 10,
   CurrentValue = 50,
   Callback = function(Value)
      Config.FlySpeed = Value
   end,
})

MoveTab:CreateToggle({
   Name = "NoClip (Pass through walls)",
   CurrentValue = false,
   Callback = function(Value)
      Config.NoClip = Value
   end,
})

-- PĘTLA GŁÓWNA (SILNIK)
RunService.RenderStepped:Connect(function()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = LocalPlayer.Character.HumanoidRootPart
    local hum = LocalPlayer.Character.Humanoid

    -- 1. Obsługa Aimbota i AutoShoot
    if Config.Aimbot then
        local target = getEnemy()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            
            if Config.AutoShoot then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end

    -- 2. Obsługa Fly (Używa przesuwania CFrame dla agresywnej detekcji)
    if Config.Fly then
        hum.PlatformStand = true
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        
        hrp.Velocity = Vector3.new(0,0,0) -- Zerowanie grawitacji
        hrp.CFrame = hrp.CFrame + (moveDir * (Config.FlySpeed / 50))
    else
        hum.PlatformStand = false
    end

    -- 3. NoClip
    if Config.NoClip then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- TELEPORTACJA DO PRZECIWNIKA (Klawisz T)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.T then
        local target = getEnemy()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            Rayfield:Notify({Title = "Teleport", Content = "Skok do: " .. target.Name})
            -- Teleport 3 study za plecy wroga
            hrp_pos = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            LocalPlayer.Character.HumanoidRootPart.CFrame = hrp_pos
        end
    end
end)

-- SEKCJA INFO
local InfoTab = Window:CreateTab("Settings", 4483362458)
InfoTab:CreateLabel("Klawisz T: Teleport do wroga")
InfoTab:CreateLabel("Skrypt pod Xeno v2")

Rayfield:Notify({
   Title = "Gotowy do testów!",
   Content = "Wszystkie systemy aktywne. Powodzenia z AC!",
   Duration = 5
})
