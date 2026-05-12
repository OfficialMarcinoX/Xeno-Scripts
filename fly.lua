-- MEGA MAŁY LOADER (Rage Mode)
print("Xeno Loader Start...")

-- 1. Odpalenie Twojego Fly z GitHuba
task.spawn(function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/OfficialMarcinoX/Xeno-Scripts/refs/heads/main/fly.lua"))()
    end)
end)

-- 2. Agresywny Aimbot & AutoShoot (Rage)
local lplr = game.Players.LocalPlayer
local mouse = lplr:GetMouse()
local rs = game:GetService("RunService")

print("Aimbot & AutoShoot Active!")

rs.RenderStepped:Connect(function()
    local target = nil
    local dist = math.huge
    
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= lplr and v.Character and v.Character:FindFirstChild("Head") and v.Character.Humanoid.Health > 0 then
            local mag = (v.Character.Head.Position - lplr.Character.Head.Position).Magnitude
            if mag < dist then
                dist = mag
                target = v
            end
        end
    end
    
    if target then
        -- Blokada kamery na głowie (Najbardziej podejrzane dla AC)
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position)
        
        -- Symulacja strzału (Klikanie)
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
        task.wait()
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end)
