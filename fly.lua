-- Ładowanie nowoczesnej biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 Script Hub",
   LoadingTitle = "Ładowanie potężnych skryptów...",
   LoadingSubtitle = "Witaj szefie, planexd_0!",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- ================= ZMIENNE GŁÓWNE =================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local Flying = false
local Speed = 50
local bv
local wybranyGracz = nil

local function pobierzGraczy()
    local lista = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name ~= player.Name then table.insert(lista, p.Name) end
    end
    return lista
end

local function getNearestPlayer()
    local nearest = nil
    local minDist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local dist = (player.Character.Head.Position - p.Character.Head.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = p.Character.Head
            end
        end
    end
    return nearest
end

local function toggleFly()
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    if Flying then
        bv = Instance.new("BodyVelocity")
        bv.Name = "XenoNapęd"
        bv.Parent = root
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

-- ================= ZAKŁADKA 1: PORUSZANIE =================
local TabPoruszanie = Window:CreateTab("Poruszanie", 4483362458)
local FlyToggle = TabPoruszanie:CreateToggle({
   Name = "Latanie (Klawisz F)", CurrentValue = false, Flag = "FlyToggle",
   Callback = function(Value) Flying = Value toggleFly() end,
})
TabPoruszanie:CreateSlider({
   Name = "Prędkość latania", Range = {10, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 50, Flag = "FlySpeed",
   Callback = function(Value) Speed = Value end,
})
mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then Flying = not Flying FlyToggle:Set(Flying) toggleFly() end
end)

-- ================= ZAKŁADKA 2: GRACZE =================
local TabGracze = Window:CreateTab("Gracze", 4483362458)
local PlayerDropdown = TabGracze:CreateDropdown({
   Name = "Wybierz cel", Options = pobierzGraczy(), CurrentOption = {""}, MultipleOptions = false, Flag = "DropdownGraczy",
   Callback = function(Option) wybranyGracz = type(Option) == "table" and Option[1] or Option end,
})
TabGracze:CreateButton({ Name = "🔄 Odśwież listę", Callback = function() PlayerDropdown:Refresh(pobierzGraczy()) end })
TabGracze:CreateButton({
   Name = "⚡ Teleportuj DO gracza",
   Callback = function()
        if wybranyGracz then
            local target = Players:FindFirstChild(wybranyGracz)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
            end
        end
   end,
})

-- ================= ZAKŁADKA 3: EXPLOIT =================
local TabExploit = Window:CreateTab("Exploit", 4483362458)
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

-- ================= ZAKŁADKA 4: RIVALS (MEGA BOJOWA) =================
local TabRivals = Window:CreateTab("🎯 RIVALS", 4483362458)
local SectionRivals = TabRivals:CreateSection("🔥 Bronie i Celowanie")

local AimbotEnabled = false
TabRivals:CreateToggle({
   Name = "🔫 Aimbot (Automatyczne namierzanie głowy)", CurrentValue = false, Flag = "AimbotToggle",
   Callback = function(Value) AimbotEnabled = Value end,
})
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetHead = getNearestPlayer()
        if targetHead then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHead.Position) end
    end
end)

local EspEnabled = false
TabRivals:CreateToggle({
   Name = "👁️ ESP (Wallhack - Czerwone postacie)", CurrentValue = false, Flag = "ESPToggle",
   Callback = function(Value)
        EspEnabled = Value
        while EspEnabled do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("PlanexESP") then
                    local highlight = Instance.new("Highlight") highlight.Name = "PlanexESP"
                    highlight.FillColor = Color3.fromRGB(255, 0, 0) highlight.FillTransparency = 0.5 highlight.Parent = p.Character
                end
            end
            task.wait(1)
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PlanexESP") then p.Character.PlanexESP:Destroy() end
        end
   end,
})

local HitboxEnabled = false
TabRivals:CreateToggle({
   Name = "💥 Magiczne Kule V2 (Strzelasz w niebo, trafiasz wroga)", CurrentValue = false, Flag = "HitboxToggle",
   Callback = function(Value)
        HitboxEnabled = Value
        while HitboxEnabled do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2048, 2048, 2048) -- Rozmiar całej mapy!
                    p.Character.HumanoidRootPart.Transparency = 1 -- Niewidzialne, żeby nie psuło Ci ekranu
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
            task.wait(1)
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
            end
        end
   end,
})

TabRivals:CreateSection("🏃 Ruch i Dominacja (8858585 Funkcji!)")

TabRivals:CreateToggle({
   Name = "🦅 Latanie (Rivals Fly)", CurrentValue = false, Flag = "RivalsFlyToggle",
   Callback = function(Value) Flying = Value toggleFly() end,
})

local InfJump = false
TabRivals:CreateToggle({
   Name = "🦘 Nieskończony Skok (Inf Jump)", CurrentValue = false, Flag = "InfJump",
   Callback = function(Value) InfJump = Value end,
})
UserInputService.JumpRequest:Connect(function()
    if InfJump and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local Noclip = false
TabRivals:CreateToggle({
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

TabRivals:CreateSlider({
   Name = "⚡ Szybkie Bieganie (WalkSpeed)", Range = {16, 200}, Increment = 1, Suffix = "WS", CurrentValue = 16, Flag = "SpeedSlider",
   Callback = function(Value)
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
        end
   end,
})

local Spinbot = false
TabRivals:CreateToggle({
   Name = "🌪️ Spinbot (Trudno Cię trafić)", CurrentValue = false, Flag = "Spinbot",
   Callback = function(Value)
        Spinbot = Value
        while Spinbot and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
            player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(50), 0)
            task.wait()
        end
   end,
})

TabRivals:CreateSlider({
   Name = "🔭 Zmiana FOV (Kąt widzenia)", Range = {70, 120}, Increment = 1, Suffix = "FOV", CurrentValue = 70, Flag = "FOV",
   Callback = function(Value)
        workspace.CurrentCamera.FieldOfView = Value
   end,
})

TabRivals:CreateSection("🧲 Kontrola Innych Graczy")

local RivalsDropdown = TabRivals:CreateDropdown({
   Name = "Wybierz wroga", Options = pobierzGraczy(), CurrentOption = {""}, MultipleOptions = false, Flag = "RivalsDropdown",
   Callback = function(Option) wybranyGracz = type(Option) == "table" and Option[1] or Option end,
})
TabRivals:CreateButton({ Name = "🔄 Odśwież listę wrogów", Callback = function() RivalsDropdown:Refresh(pobierzGraczy()) end })

TabRivals:CreateButton({
   Name = "🧲 TELEPORTUJ GRACZA DO SIEBIE (Bring)",
   Callback = function()
        if wybranyGracz then
            local target = Players:FindFirstChild(wybranyGracz)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Teleportuje wroga 5 metrów przed Twoją twarz!
                target.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                Rayfield:Notify({Title = "Magia", Content = "Gracz przyciągnięty!", Duration = 2})
            end
        end
   end,
})

TabRivals:CreateButton({
   Name = "🚀 Fling (Wyrzuć wroga w kosmos!)",
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
                Rayfield:Notify({Title = "Fling", Content = "Wróg wysłany na orbitę!", Duration = 2})
            end
        end
   end,
})

Rayfield:Notify({Title = "planexd_0 Hub", Content = "Załadowano potężny update z zakładką Rivals!", Duration = 5})
