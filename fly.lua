--[[ 
    XENO GOD HUB | 99 NOCY W LESIE EDITION
    Zasilane przez: Rayfield Engine
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Xeno | Survival HUB",
   LoadingTitle = "Ładowanie Systemu Survival...",
   LoadingSubtitle = "Witaj, planexd_0",
   ConfigurationSaving = { Enabled = false }
})

-- ==========================================
-- ZMIENNE SYSTEMOWE
-- ==========================================
local State = {
    Fly = false,
    NoClip = false,
    ESP = false,
    FlySpeed = 150
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================================
-- ZAKŁADKA 1: 99 NOCY W LESIE (SURVIVAL)
-- ==========================================
local ForestTab = Window:CreateTab("99 Nocy w Lesie", 4483362458)

ForestTab:CreateSection("Zasoby i Jedzenie")

ForestTab:CreateButton({
   Name = "Teleportuj do Jedzenia / Itemów",
   Callback = function()
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       if Root then
           local found = false
           for _, v in pairs(workspace:GetDescendants()) do
               local name = string.lower(v.Name)
               -- Szuka typowych nazw jedzenia w grach survival
               if name:match("apple") or name:match("meat") or name:match("food") or name:match("berry") or name:match("mushroom") then
                   if v:IsA("BasePart") then
                       Root.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                       found = true
                       Rayfield:Notify({Title = "Znaleziono!", Content = "Teleportowano do: " .. v.Name, Duration = 2})
                       break
                   end
               end
           end
           if not found then
               Rayfield:Notify({Title = "Błąd", Content = "Brak jedzenia na mapie w tym momencie.", Duration = 2})
           end
       end
   end,
})

ForestTab:CreateButton({
   Name = "Przyciągnij wszystkie Itemy z ziemi (Magnet)",
   Callback = function()
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       local count = 0
       if Root then
           for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("Tool") and v.Parent == workspace then
                   if v:FindFirstChild("Handle") then
                       v.Handle.CFrame = Root.CFrame
                       count = count + 1
                   end
               end
           end
           Rayfield:Notify({Title = "Magnet", Content = "Przyciągnięto " .. count .. " przedmiotów!", Duration = 3})
       end
   end,
})

ForestTab:CreateSection("Ognisko i Baza")

ForestTab:CreateButton({
   Name = "Rozpal Ognisko na MAX (Spam)",
   Callback = function()
       local fired = 0
       for _, prompt in pairs(workspace:GetDescendants()) do
           if prompt:IsA("ProximityPrompt") then
               local pName = prompt.Parent and string.lower(prompt.Parent.Name) or ""
               local aText = string.lower(prompt.ActionText)
               -- Szuka interakcji dodawania drewna / ognia
               if pName:match("fire") or pName:match("ognisko") or aText:match("wood") or aText:match("drewno") or aText:match("rozpal") then
                   if fireproximityprompt then
                       fireproximityprompt(prompt, 1)
                       fired = fired + 1
                   end
               end
           end
       end
       Rayfield:Notify({Title = "Ognisko", Content = "Użyto interakcji ogniska " .. fired .. " razy!", Duration = 3})
   end,
})

-- ==========================================
-- ZAKŁADKA 2: ADMIN ABUSE & TROLL
-- ==========================================
local AdminTab = Window:CreateTab("Admin Abuse", 4483345998)

AdminTab:CreateSection("Niszczenie Serwera")

AdminTab:CreateButton({
   Name = "Zabij wszystkie Moby/Zwierzęta (Insta-Kill)",
   Callback = function()
       local killed = 0
       for _, v in pairs(workspace:GetDescendants()) do
           if v:IsA("Model") and v:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(v) then
               v.Humanoid.Health = 0
               killed = killed + 1
           end
       end
       Rayfield:Notify({Title = "Rzeź", Content = "Zabito " .. killed .. " mobów na mapie.", Duration = 3})
   end,
})

AdminTab:CreateButton({
   Name = "Fling (Wyrzuć graczy w kosmos)",
   Callback = function()
       local Root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
       if Root then
           local Spin = Instance.new("BodyAngularVelocity")
           Spin.Name = "AdminFling"
           Spin.Parent = Root
           Spin.MaxTorque = Vector3.new(1, 1, 1) * math.huge
           Spin.AngularVelocity = Vector3.new(0, 99999, 0)
           Rayfield:Notify({Title = "Troll", Content = "Podejdź do kogoś, aby wystrzelić go w kosmos! (Kliknij ponownie by wyłączyć)", Duration = 4})
           
           -- Zabezpieczenie na wyłączenie
           task.delay(10, function()
               if Spin then Spin:Destroy() end
               Rayfield:Notify({Title = "Troll", Content = "Fling wyłączony (limit 10 sekund).", Duration = 2})
           end)
       end
   end,
})

AdminTab:CreateButton({
   Name = "Spam Dźwiękami (Troll na cały serwer)",
   Callback = function()
       for _, sound in pairs(workspace:GetDescendants()) do
           if sound:IsA("Sound") then
               sound:Play()
           end
       end
       Rayfield:Notify({Title = "Troll", Content = "Wszystkie dźwięki na mapie zostały odtworzone!", Duration = 3})
   end,
})

-- ==========================================
-- ZAKŁADKA 3: RUCH (FLY / NOCLIP)
-- ==========================================
local MoveTab = Window:CreateTab("Ruch & Fly", 4483362458)

MoveTab:CreateToggle({
   Name = "MEGA FLY (CFrame - BEZ KICKA) [Klawisz F]",
   CurrentValue = false,
   Callback = function(Value) 
       State.Fly = Value 
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
           if not State.Fly then LocalPlayer.Character.HumanoidRootPart.Anchored = false end
       end
   end,
})

MoveTab:CreateSlider({
   Name = "Prędkość Latania",
   Min = 10, Max = 500, CurrentValue = 150,
   Callback = function(Value) State.FlySpeed = Value end,
})

MoveTab:CreateToggle({
   Name = "NOCLIP (Przez Ściany)",
   CurrentValue = false,
   Callback = function(Value) State.NoClip = Value end,
})

MoveTab:CreateToggle({
   Name = "ESP (Widzenie Graczy/Mobów)",
   CurrentValue = false,
   Callback = function(Value) State.ESP = Value end,
})

-- ==========================================
-- GŁÓWNA LOGIKA (BEZPIECZNA)
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

    -- ESP HIGHLIGHT
    if State.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("Xeno_ESP")
                if not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "Xeno_ESP"
                    hl.FillColor = Color3.new(1,0,0)
                    hl.FillTransparency = 0.5
                end
            end
        end
    else
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("Xeno_ESP") then
                p.Character.Xeno_ESP:Destroy()
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
