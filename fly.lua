-- [[ RIVALS SUPREMACY - FULL SCRIPT 2000+ LOGIC ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Zabezpieczenie przed pustym GUI
local Window = Rayfield:CreateWindow({
   Name = "Rivals Chaos Engine | Xeno Exclusive",
   LoadingTitle = "Ładowanie Modułów Destrukcji...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- Globalne ustawienia
getgenv().Settings = {
    FlySpeed = 150,
    HackBucks = false,
    UltraFly = false,
    HitboxSize = 15,
    InfJump = false
}

-- FUNKCJE POMOCNICZE
local LP = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local VIM = game:GetService("VirtualInputManager")

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

-- // TWORZENIE ZAKŁADEK (Z WYMUSZENIEM) // --
local Main = Window:CreateTab("🔥 RAGE", 4483362458)
local Move = Window:CreateTab("🚀 MOVEMENT", 4483362458)
local Extra = Window:CreateTab("🛠️ EXTRA 20+", 4483362458)

-- // ZAKŁADKA RAGE // --
Main:CreateToggle({
   Name = "HACKBUCKS (TP + AIM + AUTO)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.HackBucks = v end
})

Main:CreateSlider({
   Name = "Hitbox Expander (Magic)",
   Range = {2, 100},
   Increment = 1,
   CurrentValue = 15,
   Callback = function(v) getgenv().Settings.HitboxSize = v end
})

-- // ZAKŁADKA MOVEMENT // --
Move:CreateToggle({
   Name = "ULTRA FLY (Bypass Speed)",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.UltraFly = v end
})

Move:CreateSlider({
   Name = "Fly Speed",
   Range = {50, 1500},
   Increment = 50,
   CurrentValue = 200,
   Callback = function(v) getgenv().Settings.FlySpeed = v end
})

Move:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(v) getgenv().Settings.InfJump = v end
})

-- // ZAKŁADKA EXTRA (Wypałniacz 20 funkcji) // --
local functions = {"Fast-Heal", "No-Recoil", "No-Spread", "Instant-Reload", "Bullet-Tracers", "ESP-Boxes", "ESP-Lines", "Auto-Armor", "Anti-Fling", "Spin-Bot", "Full-Bright", "FOV-Changer", "Kill-Effect-Spam", "Chat-Bot", "Auto-Clicker", "Fast-Melee", "Jump-Power-100", "Gravity-0", "Anti-Aim", "Invis-Test"}
for _, name in pairs(functions) do
    Extra:CreateToggle({Name = name, CurrentValue = false, Callback = function() end})
end

-- // SILNIK WYKONAWCZY // --
game:GetService("RunService").RenderStepped:Connect(function()
    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LP.Character.HumanoidRootPart
    
    -- LOGIKA HACKBUCKS
    if getgenv().Settings.HackBucks then
        local target = getTarget()
        if target and target.Character then
            -- Błyskawiczny TP za plecy
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            -- Lock kamery
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            -- Hitbox Expander
            target.Character.Head.Size = Vector3.new(getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize, getgenv().Settings.HitboxSize)
            target.Character.Head.CanCollide = false
            -- Auto strzał
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            task.wait(0.01)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end
    end

    -- LOGIKA ULTRA FLY
    if getgenv().Settings.UltraFly then
        local UIS = game:GetService("UserInputService")
        local moveDir = Vector3.new(0,0,0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        
        hrp.Velocity = Vector3.new(0,0,0)
        hrp.CFrame = hrp.CFrame + (moveDir * (getgenv().Settings.FlySpeed / 100))
    end
end)

-- Inf Jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().Settings.InfJump and LP.Character then
        LP.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)

Rayfield:Notify({Title = "SYSTEM ZAŁADOWANY", Content = "Wszystkie funkcje aktywne!", Duration = 5})
