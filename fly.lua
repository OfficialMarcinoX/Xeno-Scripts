-- Ładowanie biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 GOD & FLY HUB",
   LoadingTitle = "Wczytywanie Trybu Boga...",
   LoadingSubtitle = "Niszczenie serwera w toku...",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE GŁÓWNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera

-- Zmienne funkcji
local Flying, Speed, FlyMode = false, 50, "Normalny (BodyVelocity)"
local GodMode = false
local HitboxEnabled, HitboxSize = false, 50
local AimbotEnabled, TriggerBot, NoReload = false, false, false
local EspEnabled, Tracers, Chams, XRay = false, false, false, false
local FakeLag, AntiAim, SpiderMan, BunnyHop = false, false, false, false
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
    local hum = character:FindFirstChild("Humanoid")

    if Flying then
        if FlyMode == "Normalny (BodyVelocity)" or FlyMode == "Noclip Fly (Przez ściany)" then
            bv = Instance.new("BodyVelocity", root)
            bv.Name = "XenoNapęd"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            task.spawn(function()
                while Flying do
                    bv.Velocity = mouse.Hit.lookVector * Speed
                    if FlyMode == "Noclip Fly (Przez ściany)" then
                        for _, part in pairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                    task.wait()
                end
                if bv then bv:Destroy() end
            end)
        elseif FlyMode == "CFrame (Bypass Anty-Cheat)" then
            task.spawn(function()
                while Flying and root do
                    root.CFrame = root.CFrame + (mouse.Hit.lookVector * (Speed/50))
                    root.Velocity = Vector3.new(0,0,0) -- Zatrzymuje spadanie
                    task.wait()
                end
            end)
        elseif FlyMode == "Pływanie w powietrzu (SwimFly)" then
            if hum then
                workspace.Gravity = 0
                hum:ChangeState(Enum.HumanoidStateType.Swimming)
                task.spawn(function()
                    while Flying and root do
                        root.Velocity = mouse.Hit.lookVector * Speed
                        task.wait()
                    end
                    workspace.Gravity = 196.2
                end)
            end
        end
    else
        if bv then bv:Destroy() end
        workspace.Gravity = 196.2
    end
end

-- ================= ZAKŁADKA 1: 💥 DOOMSDAY & GOD MODE =================
local TabDoomsday = Window:CreateTab("⚠️ DOOMSDAY & GOD", 4483362458)

TabDoomsday:CreateToggle({
   Name = "🛡️ GOD MODE (Nieśmiertelność / 8537498537458934 HP)",
   CurrentValue = false,
   Flag = "GodMode",
   Callback = function(Value)
        GodMode = Value
        task.spawn(function()
            while GodMode do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    local hum = player.Character.Humanoid
                    hum.MaxHealth = 8537498537458934
                    hum.Health = 8537498537458934
                    -- Blokowanie stanu śmierci
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

TabDoomsday:CreateButton({
   Name = "☢️ WŁĄCZ WSZYSTKO (ARMAGEDON)",
   Callback = function()
        HitboxEnabled, AimbotEnabled, TriggerBot, NoReload = true, true, true, true
        EspEnabled, Chams, Tracers, BunnyHop = true, true, true, true
        Rayfield:Notify({Title = "DOOMSDAY", Content = "Aktywowano wszystkie systemy bojowe!", Duration = 5})
   end,
})

TabDoomsday:CreateButton({
   Name = "🛑 WYŁĄCZ WSZYSTKO (PANIC BUTTON)",
   Callback = function()
        HitboxEnabled, AimbotEnabled, TriggerBot, NoReload = false, false, false, false
        EspEnabled, Chams, Tracers, BunnyHop = false, false, false, false
        Rayfield:Notify({Title = "BEZPIECZEŃSTWO", Content = "Dezaktywowano wszystkie systemy.", Duration = 5})
   end,
})

-- ================= ZAKŁADKA 2: 🛸 SUPER LATANIE =================
local TabLatanie = Window:CreateTab("🛸 Super Latanie", 4483362458)

TabLatanie:CreateDropdown({
    Name = "Wybierz Tryb Latania",
    Options = {"Normalny (BodyVelocity)", "CFrame (Bypass Anty-Cheat)", "Noclip Fly (Przez ściany)", "Pływanie w powietrzu (SwimFly)"},
    CurrentOption = {"Normalny (BodyVelocity)"},
    MultipleOptions = false,
    Flag = "FlyModeDrop",
    Callback = function(Option)
        FlyMode = type(Option) == "table" and Option[1] or Option
        if Flying then toggleFly() toggleFly() end -- Restart latania z nowym trybem
    end,
})

local FlyToggle = TabLatanie:CreateToggle({
   Name = "🦅 Latanie (Włącz/Wyłącz - Klawisz F)", CurrentValue = false, Flag = "FlyToggle",
   Callback = function(Value) Flying = Value toggleFly() end,
})

TabLatanie:CreateSlider({
   Name = "Prędkość latania", Range = {10, 500}, Increment = 5, Suffix = "Spd", CurrentValue = 50, Flag = "FlySpeed",
   Callback = function(Value) Speed = Value end,
})

mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then Flying = not Flying FlyToggle:Set(Flying) toggleFly() end
end)

-- ================= ZAKŁADKA 3: 🔫 AUTO-BROŃ I AIMBOT =================
local TabBronie = Window:CreateTab("Bronie & Celowanie", 4483362458)

TabBronie:CreateToggle({ Name = "🔫 Aimbot (Auto-Celowanie)", CurrentValue = false, Flag = "Aimbot", Callback = function(Value) AimbotEnabled = Value end })
TabBronie:CreateToggle({ Name = "🤖 Auto-Shoot (TriggerBot)", CurrentValue = false, Flag = "TriggerBot", Callback = function(Value) TriggerBot = Value end })
TabBronie:CreateToggle({ Name = "🚀 Brak Przeładowania (No Reload)", CurrentValue = false, Flag = "NoReload", Callback = function(Value) NoReload = Value end })
TabBronie:CreateToggle({ Name = "💥 Magiczne Kule (Strzelasz byle gdzie)", CurrentValue = false, Flag = "Hitbox", Callback = function(Value) HitboxEnabled = Value end })
TabBronie:CreateSlider({ Name = "Rozmiar Głów", Range = {5, 200}, Increment = 5, Suffix = "M", CurrentValue = 50, Flag = "HitboxSize", Callback = function(Value) HitboxSize = Value end })

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

-- ================= ZAKŁADKA 4: 👁️ WIZUALNE I INNE =================
local TabWizualne = Window:CreateTab("ESP & Inne", 4483362458)
TabWizualne:CreateToggle({ Name = "🔴 ESP (Podświetlenie)", CurrentValue = false, Flag = "ESP", Callback = function(Value) EspEnabled = Value end })
TabWizualne:CreateToggle({ Name = "🌀 Spinbot (Anti-Aim)", CurrentValue = false, Flag = "AntiAim", Callback = function(Value) AntiAim = Value end })
TabWizualne:CreateToggle({ Name = "🦘 Auto Bunny Hop", CurrentValue = false, Flag = "Bhop", Callback = function(Value) BunnyHop = Value end })

UserInputService.JumpRequest:Connect(function()
    if BunnyHop and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if AntiAim and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
    end
end)

task.spawn(function()
    while task.wait(1) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                if EspEnabled and not p.Character:FindFirstChild("PlanexESP") then
                    local ch = Instance.new("Highlight", p.Character)
                    ch.Name = "PlanexESP" ch.FillColor = Color3.fromRGB(255, 0, 0) ch.FillTransparency = 0.5
                elseif not EspEnabled and p.Character:FindFirstChild("PlanexESP") then
                    p.Character.PlanexESP:Destroy()
                end
            end
        end
    end
end)

Rayfield:Notify({Title = "planexd_0 GOD HUB", Content = "Załadowano God Mode i Super Latanie!", Duration = 5})
