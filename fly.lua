-- Ładowanie biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 RIVALS DOMINATION",
   LoadingTitle = "Ładowanie Trybu Boga...",
   LoadingSubtitle = "Nikt z Tobą nie wygra.",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE GŁÓWNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Zmienne funkcji
local Flying, Noclip, Speed = false, false, 50
local GodMode, HitboxEnabled, HitboxSize = false, false, 50
local AimbotEnabled, TriggerBot, NoReload = false, false, false
local EspEnabled, Chams = false, false
local FreezeEnemies, Orbitowanie = false, false
local wybranyGracz = nil
local bv

-- Funkcje pomocnicze
local function pobierzGraczy()
    local lista = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name ~= player.Name then table.insert(lista, p.Name) end
    end
    return lista
end

local function getNearestPlayer()
    local nearest, minDist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
            local dist = (player.Character.Head.Position - player.Character.Head.Position).Magnitude
            if dist < minDist then minDist = dist nearest = p.Character.Head end
        end
    end
    return nearest
end

local function toggleFly()
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart
    if Flying then
        bv = Instance.new("BodyVelocity", root)
        bv.Name = "XenoNapęd"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while Flying do
                bv.Velocity = mouse.Hit.lookVector * Speed
                task.wait()
            end
            if bv then bv:Destroy() end
        end)
    else
        if bv then bv:Destroy() end
    end
end

-- ================= GIGANTYCZNA ZAKŁADKA RIVALS =================
local TabRivals = Window:CreateTab("🎯 RIVALS (WYGRANA)", 4483362458)

-- --- SEKCJA 1: NIEŚMIERTELNOŚĆ I CELOWANIE ---
TabRivals:CreateSection("🏆 Gwarantowana Wygrana")

TabRivals:CreateToggle({
   Name = "🛡️ GOD MODE (8537498537458934 HP)", CurrentValue = false, Flag = "GodMode",
   Callback = function(Value)
        GodMode = Value
        task.spawn(function()
            while GodMode do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local hum = player.Character.Humanoid
                    hum.MaxHealth = 8537498537458934
                    hum.Health = 8537498537458934
                    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
                end
                task.wait(0.1)
            end
            if not GodMode and player.Character and player.Character:FindFirstChild("Humanoid") then
                pcall(function() player.Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
            end
        end)
   end,
})

TabRivals:CreateToggle({ Name = "🔫 Aimbot (Auto-Headshot)", CurrentValue = false, Flag = "Aimbot", Callback = function(Value) AimbotEnabled = Value end })
TabRivals:CreateToggle({ Name = "🤖 Auto-Shoot (Sam Strzela)", CurrentValue = false, Flag = "Trigger", Callback = function(Value) TriggerBot = Value end })
TabRivals:CreateToggle({ Name = "🚀 Brak Przeładowania (No Reload)", CurrentValue = false, Flag = "NoReload", Callback = function(Value) NoReload = Value end })
TabRivals:CreateToggle({ Name = "💥 Magiczne Kule (Hitboxy)", CurrentValue = false, Flag = "Hitbox", Callback = function(Value) HitboxEnabled = Value end })
TabRivals:CreateSlider({ Name = "Rozmiar Magicznych Kul", Range = {10, 200}, Increment = 10, Suffix = "M", CurrentValue = 50, Flag = "HitboxSize", Callback = function(Value) HitboxSize = Value end })

-- --- SEKCJA 2: PORUSZANIE I PRZENIKANIE ---
TabRivals:CreateSection("🏃 Poruszanie & Ściany")

local FlyToggle = TabRivals:CreateToggle({
   Name = "🦅 Latanie (Klawisz F)", CurrentValue = false, Flag = "Fly",
   Callback = function(Value) Flying = Value toggleFly() end,
})
TabRivals:CreateSlider({ Name = "Prędkość Latania", Range = {10, 500}, Increment = 5, Suffix = "Spd", CurrentValue = 50, Flag = "FlySpeed", Callback = function(Value) Speed = Value end })
mouse.KeyDown:Connect(function(key) if key:lower() == "f" then Flying = not Flying FlyToggle:Set(Flying) toggleFly() end end)

TabRivals:CreateToggle({
   Name = "👻 Noclip (Przechodzenie przez ściany)", CurrentValue = false, Flag = "Noclip",
   Callback = function(Value) Noclip = Value end,
})
RunService.Stepped:Connect(function()
    if Noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

TabRivals:CreateSlider({ Name = "⚡ Szybkie Bieganie", Range = {16, 250}, Increment = 1, Suffix = "WS", CurrentValue = 16, Flag = "WalkSpeed", Callback = function(Value) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = Value end end })

-- --- SEKCJA 3: WIDZENIE PRZEZ ŚCIANY ---
TabRivals:CreateSection("👁️ Oczy Boga (Wizualne)")

TabRivals:CreateToggle({
   Name = "🔴 ESP (Czerwone Podświetlenie)", CurrentValue = false, Flag = "ESP",
   Callback = function(Value)
        EspEnabled = Value
        task.spawn(function()
            while EspEnabled do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and not p.Character:FindFirstChild("PlanexESP") then
                        local h = Instance.new("Highlight", p.Character) h.Name = "PlanexESP" h.FillColor = Color3.fromRGB(255, 0, 0) h.FillTransparency = 0.5
                    end
                end
                task.wait(1)
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("PlanexESP") then p.Character.PlanexESP:Destroy() end
            end
        end)
   end,
})

-- --- SEKCJA 4: MEGA TROLLE ---
TabRivals:CreateSection("🤡 MEGA Trolle na wrogach")

local RivalsDropdown = TabRivals:CreateDropdown({ Name = "Wybierz ofiarę", Options = pobierzGraczy(), CurrentOption = {""}, MultipleOptions = false, Flag = "TrollDrop", Callback = function(Option) wybranyGracz = type(Option) == "table" and Option[1] or Option end })
TabRivals:CreateButton({ Name = "🔄 Odśwież listę wrogów", Callback = function() RivalsDropdown:Refresh(pobierzGraczy()) end })

TabRivals:CreateButton({
   Name = "⚡ Teleportuj za plecy wroga",
   Callback = function()
        if wybranyGracz then
            local target = Players:FindFirstChild(wybranyGracz)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            end
        end
   end,
})

TabRivals:CreateButton({
   Name = "🚀 Fling (Wyrzuć wroga poza mapę)",
   Callback = function()
        if wybranyGracz then
            local target = Players:FindFirstChild(wybranyGracz)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local stareMiejsce = player.Character.HumanoidRootPart.CFrame
                local bg = Instance.new("BodyAngularVelocity", player.Character.HumanoidRootPart)
                bg.AngularVelocity = Vector3.new(0, 999999, 0)
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                task.wait(0.5)
                bg:Destroy()
                player.Character.HumanoidRootPart.CFrame = stareMiejsce
            end
        end
   end,
})

TabRivals:CreateToggle({
   Name = "🥶 Zamrożenie Wrogów (Tylko na Twoim ekranie)", CurrentValue = false, Flag = "Freeze",
   Callback = function(Value)
        FreezeEnemies = Value
        task.spawn(function()
            while FreezeEnemies do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.Anchored = true
                    end
                end
                task.wait(1)
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Anchored = false
                end
            end
        end)
   end,
})

-- ================= GŁÓWNE PĘTLE =================
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetHead = getNearestPlayer()
        if targetHead then camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position) end
    end
    if TriggerBot then
        local cel = mouse.Target
        if cel and cel.Parent and cel.Parent:FindFirstChild("Humanoid") and cel.Parent.Name ~= player.Name then
            pcall(function() mouse1click() end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if NoReload then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    local name = v.Name:lower()
                    if name:match("ammo") or name:match("clip") or name:match("mag") then v.Value = 999 end
                end
            end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                if HitboxEnabled then
                    p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    p.Character.Head.Transparency = 0.7
                    p.Character.Head.CanCollide = false
                else
                    p.Character.Head.Size = Vector3.new(1.2, 1, 1)
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "planexd_0 DOMINATION", Content = "Zakładka Rivals z God Mode i Noclipem załadowana!", Duration = 5})
