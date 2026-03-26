--[[ 
    XENO RIVALS GOD HUB | FINAL VERSION
    GitHub: OfficialMarcinoX
    Powered by Rayfield Engine
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | OfficialMarcinoX HUB",
   LoadingTitle = "MARCINOX REVERSE SYSTEM",
   LoadingSubtitle = "Rivals Edition",
   ConfigurationSaving = { Enabled = false }
})

-- Zmienne systemowe
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Aimbot = false
_G.AutoShoot = false
_G.NoClip = false
_G.Fly = false
_G.FlySpeed = 300

-- WSZYSTKO W JEDNEJ ZAKŁADCE RIVALS
local RivalsTab = Window:CreateTab("Rivals Cheats", 4483345998)

RivalsTab:CreateSection("Combat & Movement")

RivalsTab:CreateToggle({
   Name = "SILENT AIMBOT (Hard Lock)",
   CurrentValue = false,
   Callback = function(Value) _G.Aimbot = Value end,
})

RivalsTab:CreateToggle({
   Name = "AUTO-SHOOT (Insta-Kill)",
   CurrentValue = false,
   Callback = function(Value) _G.AutoShoot = Value end,
})

RivalsTab:CreateToggle({
   Name = "MEGA FLY (Klawisz F)",
   CurrentValue = false,
   Callback = function(Value) _G.Fly = Value end,
})

RivalsTab:CreateSlider({
   Name = "Prędkość Fly/Speed",
   Min = 50,
   Max = 1500,
   CurrentValue = 300,
   Callback = function(Value) _G.FlySpeed = Value end,
})

RivalsTab:CreateToggle({
   Name = "NOCLIP (Duch)",
   CurrentValue = false,
   Callback = function(Value) _G.NoClip = Value end,
})

RivalsTab:CreateSection("Teleports")

RivalsTab:CreateButton({
   Name = "TP DO NAJBLIŻSZEGO WROGA",
   Callback = function()
       local Target = nil
       local Dist = math.huge
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               local d = (p.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
               if d < Dist then Dist = d; Target = p end
           end
       end
       if Target then
           LocalPlayer.Character.HumanoidRootPart.CFrame = Target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
       end
   end,
})

-- GŁÓWNA LOGIKA (FIXED)
RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart

    -- 1. AGRESYWNY AIMBOT (Naprawiony pod Rivals)
    if _G.Aimbot then
        local Target = nil
        local MaxDist = 2500
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                local Pos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if OnScreen then
                    local Dist = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    if Dist < MaxDist then
                        MaxDist = Dist
                        Target = p.Character.Head
                    end
                end
            end
        end
        if Target then
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
        end
    end

    -- 2. AUTO-SHOOT (Wykorzystuje funkcje executora Xeno)
    if _G.AutoShoot then
        local TargetObj = LocalPlayer:GetMouse().Target
        if TargetObj and TargetObj.Parent and TargetObj.Parent:FindFirstChild("Humanoid") then
            local p = Players:GetPlayerFromCharacter(TargetObj.Parent)
            if p and p.Team ~= LocalPlayer.Team then
                if mouse1click then mouse1click() else mouse1press(); task.wait(0.01); mouse1release() end
            end
        end
    end

    -- 3. MEGA FLY (Zasilany przez Velocity)
    if _G.Fly then
        local BV = Root:FindFirstChild("XenoFly") or Instance.new("BodyVelocity", Root)
        BV.Name = "XenoFly"
        BV.MaxForce = Vector3.new(1, 1, 1) * 10^10
        
        local MoveDir = Vector3.new(0, 0.1, 0)
        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Camera.CFrame.RightVector end
        
        BV.Velocity = MoveDir * _G.FlySpeed
        Char.Humanoid.PlatformStand = true
    else
        if Root:FindFirstChild("XenoFly") then Root.XenoFly:Destroy() end
        Char.Humanoid.PlatformStand = false
    end
end)

-- 4. NOCLIP (Wymuszenie braku kolizji)
RunService.Stepped:Connect(function()
    if _G.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- BIND KLAWISZA F
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        _G.Fly = not _G.Fly
        Rayfield:Notify({Title = "Movement", Content = "Fly Status: " .. tostring(_G.Fly), Duration = 1})
    end
end)

Rayfield:Notify({Title = "MARCINOX HUB LOADED", Content = "Rivals Tab Ready!", Duration = 5})
