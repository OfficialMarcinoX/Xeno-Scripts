-- Ładowanie nowoczesnej biblioteki Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "planexd_0 Script Hub",
   LoadingTitle = "Ładowanie skryptów...",
   LoadingSubtitle = "by planexd_0",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- Zmienne główne
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
   Name = "⚡ Teleportuj do gracza",
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

-- ================= ZAKŁADKA 4: RIVALS (Bojowa) =================
local TabRivals = Window:CreateTab("🎯 RIVALS", 4483362458)

local AimbotEnabled = false
TabRivals:CreateToggle({
   Name = "🔫 Aimbot (Namierzanie głowy)", CurrentValue = false, Flag = "AimbotToggle",
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

-- NOWE: Bicie przez ściany / Strzelasz byle gdzie
local HitboxEnabled = false
TabRivals:CreateToggle({
   Name = "💥 Magiczne Kule (Bicie przez ściany/Byle gdzie)", CurrentValue = false, Flag = "HitboxToggle",
   Callback = function(Value)
        HitboxEnabled = Value
        while HitboxEnabled do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(40, 40, 40) -- Robi z nich gigantyczny cel
                    p.Character.HumanoidRootPart.Transparency = 0.8 -- Lekko przezroczyste, żeby nie zasłaniało ekranu
                    p.Character.HumanoidRootPart.BrickColor = BrickColor.new("Bright blue")
                    p.Character.HumanoidRootPart.CanCollide = false
                end
            end
            task.wait(1)
        end
        -- Przywracanie normy
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                p.Character.HumanoidRootPart.Transparency = 1
            end
        end
   end,
})

TabRivals:CreateButton({
   Name = "⚡ Szybki Teleport za wroga",
   Callback = function()
        local targetHead = getNearestPlayer()
        if targetHead and targetHead.Parent and targetHead.Parent:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetHead.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
        end
   end,
})

Rayfield:Notify({Title = "planexd_0 Hub", Content = "Załadowano nową funkcję Magicznych Kul!", Duration = 5})
