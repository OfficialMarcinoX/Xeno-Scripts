--[[ 
    XENO RIVALS HUB | ANTI-KICK CFRAME EDITION
    GitHub: OfficialMarcinoX
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | OfficialMarcinoX HUB",
   LoadingTitle = "Ładowanie Bezpiecznego Skryptu...",
   LoadingSubtitle = "Rivals Anti-Kick",
   ConfigurationSaving = { Enabled = false }
})

-- Bezpieczne zmienne (zamiast _G)
local State = {
    Aimbot = false,
    AutoShoot = false,
    Fly = false,
    NoClip = false,
    ESP = false,
    FlySpeed = 150 -- Zmniejszony bazowy dla CFrame (działa inaczej niż Velocity)
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- GUI
-- ==========================================
local RivalsTab = Window:CreateTab("Rivals Cheats", 4483345998)

RivalsTab:CreateToggle({
   Name = "SILENT AIMBOT (Safe Lock)",
   CurrentValue = false,
   Callback = function(Value) State.Aimbot = Value end,
})

RivalsTab:CreateToggle({
   Name = "AUTO-SHOOT",
   CurrentValue = false,
   Callback = function(Value) State.AutoShoot = Value end,
})

RivalsTab:CreateToggle({
   Name = "MEGA FLY (CFrame - BEZ KICKA)",
   CurrentValue = false,
   Callback = function(Value) 
       State.Fly = Value 
       local Char = LocalPlayer.Character
       if Char and Char:FindFirstChild("HumanoidRootPart") then
           -- Kiedy wyłączamy fly, odkotwiczamy postać, żeby normalnie spadła
           if not State.Fly then
               Char.HumanoidRootPart.Anchored = false
           end
       end
   end,
})

RivalsTab:CreateToggle({
   Name = "NOCLIP (Przez Ściany)",
   CurrentValue = false,
   Callback = function(Value) State.NoClip = Value end,
})

RivalsTab:CreateToggle({
   Name = "ESP (Widzenie przez ściany)",
   CurrentValue = false,
   Callback = function(Value) State.ESP = Value end,
})

RivalsTab:CreateSlider({
   Name = "Prędkość (Fly/Speed)",
   Min = 10,
   Max = 500,
   CurrentValue = 150,
   Callback = function(Value) State.FlySpeed = Value end,
})

-- ==========================================
-- LOGIKA (ZABEZPIECZONA)
-- ==========================================

RunService.RenderStepped:Connect(function(deltaTime)
    -- Bezpieczne sprawdzanie postaci
    local Char = LocalPlayer.Character
    if not Char then return end
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    -- 1. CFRAME FLY (Anti-Cheat Bypass)
    if State.Fly then
        Root.Anchored = true -- Zatrzymujemy fizykę (Anti-Cheat nie widzi ruchu)
        
        local MoveDir = Vector3.new(0, 0, 0)
        local Look = Camera.CFrame.LookVector
        local Right = Camera.CFrame.RightVector
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir = MoveDir - Vector3.new(0, 1, 0) end
        
        -- Normalizujemy wektor ruchu, żeby nie latać szybciej na skos
        if MoveDir.Magnitude > 0 then
            MoveDir = MoveDir.Unit
        end
        
        -- Przesuwamy postać
        Root.CFrame = Root.CFrame + (MoveDir * (State.FlySpeed * deltaTime))
    end

    -- 2. BEZPIECZNY AIMBOT
    if State.Aimbot then
        pcall(function() -- Pcall zapobiega crashom, jeśli ktoś zginie w trakcie celowania
            local Target = nil
            local MinDist = math.huge
            
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                    local HeadPos = p.Character.Head.Position
                    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(HeadPos)
                    
                    if OnScreen then
                        local MousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        local Dist = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                        
                        if Dist < MinDist then
                            MinDist = Dist
                            Target = p.Character.Head
                        end
                    end
                end
            end
            
            if Target then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
                
                if State.AutoShoot then
                    -- Próba strzału
                    if mouse1press then
                        mouse1press(); task.wait(0.01); mouse1release()
                    end
                end
            end
        end)
    end

    -- 3. ESP HIGHLIGHT
    if State.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("MarcinoX_ESP")
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "MarcinoX_ESP"
                    hl.Parent = p.Character
                    hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.new(1,1,1)
                end
            end
        end
    else
        -- Usuwanie ESP, gdy wyłączone
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MarcinoX_ESP") then
                p.Character.MarcinoX_ESP:Destroy()
            end
        end
    end
end)

-- 4. NOCLIP
RunService.Stepped:Connect(function()
    if State.NoClip then
        local Char = LocalPlayer.Character
        if Char then
            for _, v in pairs(Char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end
end)

-- BIND F
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        State.Fly = not State.Fly
        if not State.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
        Rayfield:Notify({Title = "Fly Status", Content = State.Fly and "Włączone (CFrame)" or "Wyłączone", Duration = 1})
    end
end)

Rayfield:Notify({Title = "Gotowe!", Content = "Zaktualizowano system przeciw Kickom.", Duration = 4})
