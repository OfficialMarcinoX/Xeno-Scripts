-- Rivals AC Tester for Xeno
-- Cechy: Auto-Lock, Auto-Shoot, NoClip, Full-Bright

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Ustawienia
local Aiming = true
local AutoShoot = true
local NoClip = true

-- Funkcja szukania celu (Najbliższy Head)
local function getClosestPlayer()
    local target = nil
    local shortestDistance = math.huge

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    target = v
                end
            end
        end
    end
    return target
end

-- Pętla Główna (SILNIK)
RunService.RenderStepped:Connect(function()
    -- 1. AIMBOT & AUTOSHOOT
    if Aiming then
        local target = getClosestPlayer()
        if target and target.Character then
            -- Agresywne blokowanie kamery na głowie
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            
            -- Auto strzelanie przez VirtualInputManager
            if AutoShoot then
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                task.wait()
                game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
            end
        end
    end

    -- 2. NO CLIP (Przechodzenie przez ściany)
    if NoClip then
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- Informacja w konsoli Xeno
print("--- Rivals Rage Loaded ---")
print("Aimbot: ON")
print("NoClip: ON")
print("Testuj detekcję CFrame i CanCollide!")
