--[[ 
    XENO RIVALS ULTIMATE HUB | POWERED BY RAYFIELD
    GitHub: OfficialMarcinoX
    Features: Auto-Shoot, Silent Aim, Fixed Fly (F), Fixed NoClip, TP
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | OfficialMarcinoX HUB",
   LoadingTitle = "Initializing Reverse Engine...",
   LoadingSubtitle = "by MarcinoX",
   ConfigurationSaving = { Enabled = true, FolderName = "XenoRivals", FileName = "Config" }
})

-- Zmienne
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

_G.Aimbot = false
_G.AutoShoot = false
_G.NoClip = false
_G.Fly = false
_G.FlySpeed = 200

-- ZAKŁADKA RIVALS (COMBAT)
local CombatTab = Window:CreateTab("Combat & Aim", 4483345998)

CombatTab:CreateToggle({
   Name = "Silent Aim / Lock-On",
   CurrentValue = false,
   Callback = function(Value) _G.Aimbot = Value end,
})

CombatTab:AddLabel("Auto-Shoot (Automatyczne strzelanie)")
CombatTab:CreateToggle({
   Name = "Auto-Shoot",
   CurrentValue = false,
   Callback = function(Value) _G.AutoShoot = Value end,
})

-- ZAKŁADKA MOVEMENT
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "Mega Fly (Klawisz F)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly = Value
      if not Value then
          if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
              local Root = LocalPlayer.Character.HumanoidRootPart
              if Root:FindFirstChild("FlyVelocity") then Root.FlyVelocity:Destroy() end
              if Root:FindFirstChild("FlyGyro") then Root.FlyGyro:Destroy() end
              LocalPlayer.Character.Humanoid.PlatformStand = false
          end
      end
   end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Min = 50,
   Max = 1000,
   CurrentValue = 200,
   Callback = function(Value) _G.FlySpeed = Value end,
})

MoveTab:CreateToggle({
   Name = "NoClip (Przez ściany)",
   CurrentValue = false,
   Callback = function(Value) _G.NoClip = Value end,
})

-- ZAKŁADKA TELEPORT
local TPTab = Window:CreateTab("Teleport", 4483345998)

TPTab:CreateButton({
   Name = "TP to Random Enemy",
   Callback = function()
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
               LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
               break
           end
       end
   end,
})

-- GŁÓWNA LOGIKA (LOOPY)
RunService.RenderStepped:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Root = Char.HumanoidRootPart

    -- POPRAWIONY FLY
    if _G.Fly then
        local BV = Root:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity", Root)
        local BG = Root:FindFirstChild("FlyGyro") or Instance.new("BodyGyro", Root)
        
        BV.Name = "FlyVelocity"
        BG.Name = "FlyGyro"
        
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        
        local Dir = Vector3.new(0,0.1,0) -- Anty-grawitacja
        if UIS:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Camera.CFrame.RightVector end
        
        BV.Velocity = Dir * _G.FlySpeed
        BG.CFrame = Camera.CFrame
        Char.Humanoid.PlatformStand = true
    end

    -- POPRAWIONY AIMBOT & AUTO-SHOOT
    if _G.Aimbot or _G.AutoShoot then
        local Target = nil
        local MaxDist = 2000
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
            if _G.Aimbot then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
            end
            if _G.AutoShoot then
                -- Symulacja kliknięcia myszką (Mouse1)
                mouse1click() 
            end
        end
    end
end)

-- NOCLIP FIX
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
        Rayfield:Notify({Title = "Status", Content = "Fly: " .. tostring(_G.Fly), Duration = 2})
    end
end)

Rayfield:Notify({Title = "Xeno Loaded", Content = "Zasilane przez Reverse System - OfficialMarcinoX", Duration = 5})
