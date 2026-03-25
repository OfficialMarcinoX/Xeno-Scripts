-- Ładowanie biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 GOD HUB",
   LoadingTitle = "Wczytywanie uprawnień ROOT...",
   LoadingSubtitle = "Przejmowanie serwera...",
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

local Flying, Noclip, Speed, InfJump = false, false, 50, false
local HitboxEnabled, HitboxSize = false, 50
local bv
local wybranyGracz = nil

-- ================= FUNKCJE POMOCNICZE =================
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
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (player.Character.Head.Position - player.Character.Head.Position).Magnitude
            if dist < minDist then minDist = dist nearest = p.Character.Head end
        end
    end
    return nearest
end

local function toggleFly()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = player.Character.HumanoidRootPart
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

-- ================= ZAKŁADKA 1: 🎯 BOJOWE =================
local TabBojowe = Window:CreateTab("Bojowe / Rivals", 4483362458)

TabBojowe:CreateToggle({
   Name = "💥 Magiczne Kule (Strzelasz byle gdzie)", CurrentValue = false, Flag = "Hitbox",
   Callback = function(Value) HitboxEnabled = Value end,
})
TabBojowe:CreateSlider({
   Name = "Rozmiar Głów", Range = {5, 200}, Increment = 5, Suffix = "M", CurrentValue = 50, Flag = "HitboxSize",
   Callback = function(Value) HitboxSize = Value end,
})

task.spawn(function()
    while task.wait(0.5) do
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                if HitboxEnabled then
                    p.Character.Head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                    p.Character.Head.Transparency = 0.7
                    p.Character.Head.CanCollide = false
                    p.Character.Head.Massless = true
                else
                    p.Character.Head.Size = Vector3.new(1.2, 1, 1)
                    p.Character.Head.Transparency = 0
                end
            end
        end
    end
end)

local AimbotEnabled = false
TabBojowe:CreateToggle({
   Name = "🔫 Aimbot (Auto-Celowanie)", CurrentValue = false, Flag = "Aimbot",
   Callback = function(Value) AimbotEnabled = Value end,
})
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetHead = getNearestPlayer()
        if targetHead then camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position) end
    end
end)

-- ================= ZAKŁADKA 2: 🧲 KONTROLA GRACZY =================
local TabGracze = Window:CreateTab("Gracze (Troll)", 4483362458)
local PlayerDropdown = TabGracze:CreateDropdown({
   Name = "Wybierz ofiarę", Options = pobierzGraczy(), CurrentOption = {""}, MultipleOptions = false, Flag = "DropdownGraczy",
   Callback = function(Option) wybranyGracz = type(Option) == "table" and Option[1] or Option end,
})
TabGracze:CreateButton({ Name = "🔄 Odśwież listę", Callback = function() PlayerDropdown:Refresh(pobierzGraczy()) end })

local LoopTP = false
TabGracze:CreateToggle({
   Name = "🔄 Loop TP (Zawsze bądź ZA NIM)", CurrentValue = false, Flag = "LoopTP",
   Callback = function(Value)
        LoopTP = Value
        task.spawn(function()
            while LoopTP do
                if wybranyGracz then
                    local target = Players:FindFirstChild(wybranyGracz)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                    end
                end
                task.wait(0.05) -- Szybkość odświeżania teleportu
            end
        end)
   end,
})

local LoopBring = false
TabGracze:CreateToggle({
   Name = "🧲 Loop Bring (Zawsze trzymaj go PRZED SOBĄ)", CurrentValue = false, Flag = "LoopBring",
   Callback = function(Value)
        LoopBring = Value
        task.spawn(function()
            while LoopBring do
                if wybranyGracz then
                    local target = Players:FindFirstChild(wybranyGracz)
                    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        target.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -4)
                    end
                end
                task.wait(0.05)
            end
        end)
   end,
})

TabGracze:CreateButton({
   Name = "🚀 Wyrzuć poza mapę (Fling)",
   Callback = function()
        if wybranyGracz then
            local target = Players:FindFirstChild(wybranyGracz)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local stareMiejsce = player.Character.HumanoidRootPart.CFrame
                local bg = Instance.new("BodyAngularVelocity", player.Character.HumanoidRootPart)
                bg.AngularVelocity = Vector3.new(0, 99999, 0)
                bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                task.wait(0.5)
                bg:Destroy()
                player.Character.HumanoidRootPart.CFrame = stareMiejsce
            end
        end
   end,
})

-- ================= ZAKŁADKA 3: 💻 HACKOWANIE GRY (DEX) =================
local TabExploit = Window:CreateTab("Dev / Exploit", 4483362458)
TabExploit:CreateSection("Przejmowanie uprawnień")

TabExploit:CreateButton({
   Name = "🔓 DEX EXPLORER V3 (Dostęp do skryptów gry!)",
   Callback = function()
        Rayfield:Notify({Title = "Wstrzykiwanie", Content = "Otwieram Dex Explorer... Trwa łamanie plików gry.", Duration = 4})
        -- Odpala legendarnego Dex'a do czytania wszystkich plików z gry
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
   end,
})

TabExploit:CreateButton({
   Name = "🌌 Zmień niebo na CZARNE (7 sekund)",
   Callback = function()
        local stareTime = Lighting.TimeOfDay local starySky = Lighting:FindFirstChildOfClass("Sky")
        Lighting.TimeOfDay = "00:00:00" Lighting.GlobalShadows = false Lighting.Ambient = Color3.new(0, 0, 0)
        if starySky then starySky.Parent = nil end
        local czarneNiebo = Instance.new("Sky") czarneNiebo.Parent = Lighting
        task.delay(7, function()
            czarneNiebo:Destroy() if starySky then starySky.Parent = Lighting end
            Lighting.TimeOfDay = stareTime Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        end)
   end,
})

-- ================= ZAKŁADKA 4: 🏃 RUCH & WIZUALNE =================
local TabRuch = Window:CreateTab("Ruch & ESP", 4483362458)

local EspEnabled = false
TabRuch:CreateToggle({
   Name = "👁️ ESP (Podświetlenie graczy)", CurrentValue = false, Flag = "ESP",
   Callback = function(Value)
        EspEnabled = Value
        task.spawn(function()
            while EspEnabled do
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and not p.Character:FindFirstChild("PlanexESP") then
                        local h = Instance.new("Highlight") h.Name = "PlanexESP"
                        h.FillColor = Color3.fromRGB(255, 0, 0) h.FillTransparency = 0.5 h.Parent = p.Character
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

local FlyToggle = TabRuch:CreateToggle({
   Name = "🦅 Latanie (Klawisz F)", CurrentValue = false, Flag = "Fly",
   Callback = function(Value) Flying = Value toggleFly() end,
})
TabRuch:CreateSlider({ Name = "Prędkość latania", Range = {10, 300}, Increment = 1, Suffix = "Spd", CurrentValue = 50, Flag = "FlySpd", Callback = function(Value) Speed = Value end })
mouse.KeyDown:Connect(function(key) if key:lower() == "f" then Flying = not Flying FlyToggle:Set(Flying) toggleFly() end end)

TabRuch:CreateSlider({ Name = "⚡ Szybkie Bieganie", Range = {16, 250}, Increment = 1, Suffix = "WS", CurrentValue = 16, Flag = "WalkSpeed", Callback = function(Value) if player.Character and player.Character:FindFirstChild("Humanoid") then player.Character.Humanoid.WalkSpeed = Value end end })

TabRuch:CreateToggle({
   Name = "👻 Przenikanie przez ściany (NoClip)", CurrentValue = false, Flag = "Noclip",
   Callback = function(Value) Noclip = Value end,
})
RunService.Stepped:Connect(function()
    if Noclip and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

Rayfield:Notify({Title = "planexd_0 GOD Hub", Content = "Zaktualizowano! Odblokowano Dex Explorer!", Duration = 5})
