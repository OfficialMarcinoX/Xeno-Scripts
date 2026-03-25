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
local TabPoruszanie = Window:CreateTab("Poruszanie się", 4483362458)
local FlyToggle = TabPoruszanie:CreateToggle({
   Name = "Latanie (Klawisz F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value) Flying = Value toggleFly() end,
})

TabPoruszanie:CreateSlider({
   Name = "Prędkość latania",
   Range = {10, 300}, Increment = 1, Suffix = "Speed", CurrentValue = 50, Flag = "FlySpeed",
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

TabGracze:CreateButton({
   Name = "🔄 Odśwież listę graczy",
   Callback = function() PlayerDropdown:Refresh(pobierzGraczy()) end,
})

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
        
        Lighting.TimeOfDay = "00:00:00"
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0, 0, 0)
        if starySky then starySky.Parent = nil end
        
        local czarneNiebo = Instance.new("Sky")
        czarneNiebo.SkyboxBk = "rbxassetid://0" czarneNiebo.SkyboxDn = "rbxassetid://0" czarneNiebo.SkyboxFt = "rbxassetid://0"
        czarneNiebo.SkyboxLf = "rbxassetid://0" czarneNiebo.SkyboxRt = "rbxassetid://0" czarneNiebo.SkyboxUp = "rbxassetid://0"
        czarneNiebo.Parent = Lighting
        
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local nazwa = v.Name:lower()
                if nazwa:match("light") or nazwa:match("sky") or nazwa:match("time") then
                    pcall(function() v:FireServer("00:00:00") end)
                end
            end
        end
        
        task.delay(7, function()
            czarneNiebo:Destroy()
            if starySky then starySky.Parent = Lighting end
            Lighting.TimeOfDay = stareTime
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
        end)
   end,
})

-- ================= ZAKŁADKA 4: TROLL (Fake Robux) =================
local TabTroll = Window:CreateTab("Troll / Fake", 4483362458)
TabTroll:CreateButton({
   Name = "💰 Nieskończone Robuxy (Wizualne do screenów)",
   Callback = function()
        -- Tworzenie ogromnego, fejkowego interfejsu Robuxów na ekranie
        local fakeUI = Instance.new("ScreenGui")
        fakeUI.Name = "FakeRobuxUI"
        fakeUI.Parent = CoreGui
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(0, 500, 0, 100)
        textLabel.Position = UDim2.new(0.5, -250, 0.2, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = "+ 999,999,999 R$"
        textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        textLabel.TextScaled = true
        textLabel.Font = Enum.Font.FredokaOne
        textLabel.TextStrokeTransparency = 0
        textLabel.Parent = fakeUI
        
        -- Dźwięk monet
        local dzwiek = Instance.new("Sound")
        dzwiek.SoundId = "rbxassetid://134756317" -- Dźwięk kasy
        dzwiek.Volume = 2
        dzwiek.Parent = CoreGui
        dzwiek:Play()
        
        -- Animacja powiększania się tekstu
        for i = 1, 10 do
            textLabel.TextTransparency = textLabel.TextTransparency - 0.1
            task.wait(0.05)
        end
        
        Rayfield:Notify({Title = "HACK ZAKOŃCZONY", Content = "Robuxy zostały wygenerowane wizualnie na Twoim ekranie!", Duration = 5})
        
        -- Usunięcie po 10 sekundach
        task.delay(10, function()
            fakeUI:Destroy()
            dzwiek:Destroy()
        end)
   end,
})

Rayfield:Notify({Title = "planexd_0 Hub", Content = "Wgrano z zakładką Troll (Fake Robux)!", Duration = 5})
