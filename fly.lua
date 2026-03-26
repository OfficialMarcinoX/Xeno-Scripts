--[[ 
    XENO GOD HUB | MULTI-GAME EDITION
    GitHub: OfficialMarcinoX
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | OfficialMarcinoX HUB",
   LoadingTitle = "Ładowanie Systemu...",
   LoadingSubtitle = "Zalogowano jako: planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- ==========================================
-- GŁÓWNE ZMIENNE
-- ==========================================
local State = {
    Aimbot = false, AutoShoot = false, Fly = false,
    NoClip = false, ESP = false, FlySpeed = 150
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- ZAKŁADKA 1: RIVALS CHEATS
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
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           if not State.Fly then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
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
   Min = 10, Max = 500, CurrentValue = 150,
   Callback = function(Value) State.FlySpeed = Value end,
})

-- ==========================================
-- ZAKŁADKA 2: 99 NOCY W LESIE (SURVIVAL)
-- ==========================================
local ForestTab = Window:CreateTab("99 Nocy w Lesie", 4483362458)

ForestTab:CreateButton({
   Name = "Zabij wszystkie zwierzęta (Moby)",
   Callback = function()
       local killed = 0
       -- Skanuje całą mapę w poszukiwaniu "Humanoidów", które nie są graczami
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("Model") and v:FindFirstChild("Humanoid") then
               if not Players:GetPlayerFromCharacter(v) then
                   v.Humanoid.Health = 0
                   killed = killed + 1
               end
           end
       end
       Rayfield:Notify({Title = "Sukces!", Content = "Zabito " .. killed .. " zwierząt/mobów.", Duration = 3})
   end,
})

ForestTab:CreateButton({
   Name = "Teleportuj do Skrzynki / Bazy",
   Callback = function()
       local found = false
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       if Root then
           -- Szuka na mapie obiektów o nazwie chest, skrzynka, storage itp.
           for _, v in pairs(workspace:GetDescendants()) do
               local name = string.lower(v.Name)
               if name:match("chest") or name:match("skrzyn") or name:match("storage") or name:match("box") then
                   if v:IsA("BasePart") then
                       Root.CFrame = v.CFrame * CFrame.new(0, 3, 0)
                       found = true
                       break
                   elseif v:IsA("Model") and v.PrimaryPart then
                       Root.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
                       found = true
                       break
                   end
               end
           end
       end
       if not found then
           Rayfield:Notify({Title = "Błąd", Content = "Nie wykryto żadnej skrzynki na mapie!", Duration = 3})
       else
           Rayfield:Notify({Title = "Teleport", Content = "Przeteleportowano do skrzynki.", Duration = 2})
       end
   end,
})

ForestTab:CreateButton({
   Name = "Przyciągnij wszystkie Itemy z mapy",
   Callback = function()
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       local itemsBrought = 0
       if Root then
           for _, v in pairs(workspace:GetDescendants()) do
               -- Przyciąga narzędzia (Tools) leżące luźno na mapie
               if v:IsA("Tool") and v.Parent == workspace then
                   if v:FindFirstChild("Handle") then
                       v.Handle.CFrame = Root.CFrame
                       itemsBrought = itemsBrought + 1
                   end
               -- Przyciąga części, które mają właściwości do podnoszenia (TouchInterest)
               elseif v:IsA("BasePart") and v:FindFirstChild("TouchInterest") then
                   v.CFrame = Root.CFrame
                   itemsBrought = itemsBrought + 1
               end
           end
           Rayfield:Notify({Title = "Zrzut Itemów", Content = "Przyciągnięto " .. itemsBrought .. " przedmiotów do Ciebie!", Duration = 3})
       end
   end,
})

-- ==========================================
-- GŁÓWNA LOGIKA (ZABEZPIECZONA)
-- ==========================================

RunService.RenderStepped:Connect(function(deltaTime)
    local Char = LocalPlayer.Character
    if not Char then return end
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if not Root then return end

    -- CFRAME FLY
    if State.Fly then
        Root.Anchored = true
        local MoveDir = Vector3.new(0, 0, 0)
        local Look = Camera.CFrame.LookVector
        local Right = Camera.CFrame.RightVector
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then MoveDir = MoveDir + Look end
        if UIS:IsKeyDown(Enum.KeyCode.S) then MoveDir = MoveDir - Look end
        if UIS:IsKeyDown(Enum.KeyCode.A) then MoveDir = MoveDir - Right end
        if UIS:IsKeyDown(Enum.KeyCode.D) then MoveDir = MoveDir + Right end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then MoveDir = MoveDir + Vector3.new(0, 1, 0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then MoveDir = MoveDir - Vector3.new(0, 1, 0) end
        
        if MoveDir.Magnitude > 0 then MoveDir = MoveDir.Unit end
        Root.CFrame = Root.CFrame + (MoveDir * (State.FlySpeed * deltaTime))
    end

    -- AIMBOT & AUTO-SHOOT
    if State.Aimbot then
        pcall(function()
            local Target, MinDist = nil, math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Team ~= LocalPlayer.Team and p.Character and p.Character:FindFirstChild("Head") then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(p.Character.Head.Position)
                    if OnScreen then
                        local MousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                        local Dist = (Vector2.new(Pos.X, Pos.Y) - MousePos).Magnitude
                        if Dist < MinDist then MinDist = Dist; Target = p.Character.Head end
                    end
                end
            end
            if Target then
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Target.Position)
                if State.AutoShoot and mouse1press then mouse1press(); task.wait(0.01); mouse1release() end
            end
        end)
    end

    -- ESP HIGHLIGHT
    if State.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("MarcinoX_ESP")
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "MarcinoX_ESP"
                    hl.FillColor = (p.Team == LocalPlayer.Team) and Color3.new(0,1,0) or Color3.new(1,0,0)
                    hl.FillTransparency = 0.5
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("MarcinoX_ESP") then
                p.Character.MarcinoX_ESP:Destroy()
            end
        end
    end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
    if State.NoClip and LocalPlayer.Character then
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- BIND F (Globalny przełącznik latania)
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.F then
        State.Fly = not State.Fly
        if not State.Fly and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.Anchored = false
        end
        Rayfield:Notify({Title = "Fly Status", Content = State.Fly and "Włączone (CFrame)" or "Wyłączone", Duration = 1})
    end
end)
