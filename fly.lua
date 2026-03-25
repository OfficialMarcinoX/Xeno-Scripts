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

-- Funkcje pomocnicze
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
   Name = "Latanie (Klawisz F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value) Flying = Value toggleFly() end,
})
TabPoruszanie:CreateSlider({
   Name = "Prędkość latania", Range = {10, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 50, Flag = "FlySpeed",
   Callback = function(Value) Speed = Value end,
})

mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        Flying = not Flying
        FlyToggle:Set(Flying)
        toggleFly()
    end
end)

-- ================= ZAKŁADKA 2: GRACZE =================
local TabGracze = Window:CreateTab("Gracze", 4483362458)
local PlayerDropdown = TabGracze:CreateDropdown({
   Name = "Wybierz cel", Options = pobierzGraczy(), CurrentOption = {""}, MultipleOptions = false, Flag = "DropdownGraczy",
   Callback = function(Option) wybranyGracz = type(Option) == "table" and Option[1] or Option end,
})
TabGracze:CreateButton({ Name = "🔄 Odśwież listę graczy", Callback = function() PlayerDropdown:Refresh(pobierzGraczy()) end })
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
        local stareTime = Lighting.TimeOfDay
        local starySky = Lighting:FindFirstChildOfClass("Sky")
        Lighting.TimeOfDay = "00:00:00" Lighting.GlobalShadows = false Lighting.Ambient = Color3.new(0, 0, 0)
        if starySky then starySky.Parent = nil end
        
        local czarneNiebo = Instance.new("Sky")
        czarneNiebo.SkyboxBk = "rbxassetid://0" czarneNiebo.SkyboxDn = "rbxassetid://0" czarneNiebo.SkyboxFt = "rbxassetid://0"
        czarneNiebo.SkyboxLf = "rbxassetid://0" czarneNiebo.SkyboxRt = "rbxassetid://0" czarneNiebo.SkyboxUp = "rbxassetid://0"
        czarneNiebo.Parent = Lighting
        
        task.delay(7, function()
            czarneNiebo:Destroy()
            if starySky then starySky.Parent = Lighting end
            Lighting.TimeOfDay = stareTime
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        end)
   end,
})

-- ================= ZAKŁADKA 4: TROLL =================
local TabTroll = Window:CreateTab("Troll / Fake", 4483362458)
TabTroll:CreateButton({
   Name = "💰 Nieskończone Robuxy (Fejk na ekran)",
   Callback = function()
        local fakeUI = Instance.new("ScreenGui") fakeUI.Parent = CoreGui
        local textLabel = Instance.new("TextLabel") textLabel.Size = UDim2.new(0, 500, 0, 100)
        textLabel.Position = UDim2.new(0.5, -250, 0.2, 0) textLabel.BackgroundTransparency = 1
        textLabel.Text = "+ 999,999,999 R$" textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        textLabel.TextScaled = true textLabel.Font = Enum.Font.FredokaOne textLabel.Parent = fakeUI
        task.delay(5, function() fakeUI:Destroy() end)
   end,
})

-- ================= ZAKŁADKA 5: RIVALS (NOWA!) =================
local TabRivals = Window:CreateTab("🎯 RIVALS", 4483362458)
local SectionRivals = TabRivals:CreateSection("Funkcje Bojowe")

-- Aimbot
local AimbotEnabled = false
TabRivals:CreateToggle({
   Name = "🔫 Aimbot (Automatyczne namierzanie głowy)",
   CurrentValue = false,
   Flag = "AimbotToggle",
   Callback = function(Value)
        AimbotEnabled = Value
   end,
})

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local targetHead = getNearestPlayer()
        if targetHead then
            workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetHead.Position)
        end
    end
end)

-- ESP (Wallhack)
local EspEnabled = false
TabRivals:CreateToggle({
   Name = "👁️ ESP (Widzenie graczy przez ściany)",
   CurrentValue = false,
   Flag = "ESPToggle",
   Callback = function(Value)
        EspEnabled = Value
        while EspEnabled do
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    if not p.Character:FindFirstChild("PlanexESP") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "PlanexESP"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Czerwony
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.FillTransparency = 0.5
                        highlight.Parent = p.Character
                    end
                end
            end
            task.wait(1)
        end
        -- Usuwanie ESP po wyłączeniu
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PlanexESP") then
                p.Character.PlanexESP:Destroy()
            end
        end
   end,
})

-- Szybki TP w Rivals
TabRivals:CreateButton({
   Name = "⚡ Szybki Teleport za najbliższego wroga",
   Callback = function()
        local targetHead = getNearestPlayer()
        if targetHead and targetHead.Parent and targetHead.Parent:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetHead.Parent.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
            Rayfield:Notify({Title = "Rivals TP", Content = "Zteleportowano za plecy wroga!", Duration = 2})
        else
            Rayfield:Notify({Title = "Błąd", Content = "Brak wrogów w pobliżu!", Duration = 2})
        end
   end,
})

-- Fake Keys
TabRivals:CreateButton({
   Name = "🔑 Nieskończoność Keys (Fejk do screenów)",
   Callback = function()
        local fakeUI = Instance.new("ScreenGui") fakeUI.Name = "FakeKeysUI" fakeUI.Parent = CoreGui
        local textLabel = Instance.new("TextLabel") textLabel.Size = UDim2.new(0, 600, 0, 120)
        textLabel.Position = UDim2.new(0.5, -300, 0.3, 0) textLabel.BackgroundTransparency = 1
        textLabel.Text = "🔑 +999,999 INFINITE KEYS UNLOCKED" textLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Złoty
        textLabel.TextScaled = true textLabel.Font = Enum.Font.FredokaOne textLabel.TextStrokeTransparency = 0 textLabel.Parent = fakeUI
        
        Rayfield:Notify({Title = "Rivals Hack", Content = "Klucze wygenerowane na ekranie!", Duration = 4})
        task.delay(7, function() fakeUI:Destroy() end)
   end,
})

Rayfield:Notify({Title = "planexd_0 Hub", Content = "Wgrano potężną aktualizację z zakładką RIVALS!", Duration = 5})
