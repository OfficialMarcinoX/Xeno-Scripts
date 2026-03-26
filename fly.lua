--[[ 
    XENO RIVALS HUB | POWERED BY RAYFIELD ENGINE
    GitHub: OfficialMarcinoX
    Features: Aimbot, Mega Fly (F), NoClip, TP
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | OfficialMarcinoX",
   LoadingTitle = "Reverse Engine Loading...",
   LoadingSubtitle = "by MarcinoX",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "XenoMarcinoX",
      FileName = "RivalsConfig"
   }
})

-- Zmienne logiczne
_G.Aimbot = false
_G.NoClip = false
_G.Fly = false
_G.Speed = 250

-- ZAKŁADKA RIVALS
local MainTab = Window:CreateTab("Rivals Combat", 4483345998)

MainTab:CreateToggle({
   Name = "Aimbot Lock-On",
   CurrentValue = false,
   Callback = function(Value)
      _G.Aimbot = Value
   end,
})

-- ZAKŁADKA MOVEMENT
local MoveTab = Window:CreateTab("Movement", 4483362458)

MoveTab:CreateToggle({
   Name = "Mega Fly (Klawisz F)",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fly = Value
      if _G.Fly then StartFly() else StopFly() end
   end,
})

MoveTab:CreateSlider({
   Name = "Fly Speed",
   Min = 50,
   Max = 1000,
   CurrentValue = 250,
   Callback = function(Value)
      _G.Speed = Value
   end,
})

MoveTab:CreateToggle({
   Name = "NoClip (Wall-Walk)",
   CurrentValue = false,
   Callback = function(Value)
      _G.NoClip = Value
   end,
})

-- LOGIKA SILNIKA (FLY / AIM / NOCLIP)
local BodyGyro, BodyVelocity
function StartFly()
    local Root = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    BodyGyro = Instance.new("BodyGyro", Root)
    BodyVelocity = Instance.new("BodyVelocity", Root)
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    
    task.spawn(function()
        while _G.Fly do
            local Camera = workspace.CurrentCamera
            local Dir = Vector3.new(0,0,0)
            local UIS = game:GetService("UserInputService")
            
            if UIS:IsKeyDown(Enum.KeyCode.W) then Dir = Dir + Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then Dir = Dir - Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then Dir = Dir - Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then Dir = Dir + Camera.CFrame.RightVector end
            
            BodyVelocity.Velocity = Dir * _G.Speed
            BodyGyro.CFrame = Camera.CFrame
            task.wait()
        end
        StopFly()
    end)
end

function StopFly()
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
end

-- Klawisz F Toggle
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        _G.Fly = not _G.Fly
        if _G.Fly then StartFly() else StopFly() end
        Rayfield:Notify({Title = "Fly Status", Content = "Fly: " .. tostring(_G.Fly), Duration = 2})
    end
end)

-- Aimbot & NoClip Loops
game:GetService("RunService").RenderStepped:Connect(function()
    if _G.Aimbot then
        -- Logika celowania w głowę najbliższego wroga w Rivals
        local target = nil
        local dist = 1000
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character and p.Team ~= game.Players.LocalPlayer.Team then
                local head = p.Character:FindFirstChild("Head")
                if head then
                    local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(workspace.CurrentCamera.ViewportSize.X/2, workspace.CurrentCamera.ViewportSize.Y/2)).Magnitude
                        if mag < dist then dist = mag; target = head end
                    end
                end
            end
        end
        if target then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Position)
        end
    end
    
    if _G.NoClip then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)
