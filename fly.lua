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
local Flying = false
local Speed = 50
local bv
local wybranyGracz = nil

-- Funkcja pobierania listy graczy
local function pobierzGraczy()
    local lista = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p.Name ~= player.Name then
            table.insert(lista, p.Name)
        end
    end
    return lista
end

-- Funkcja latania
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

-- Zakładka 1: Poruszanie się (Latanie)
local TabPoruszanie = Window:CreateTab("Poruszanie się", 4483362458)
local SectionFly = TabPoruszanie:CreateSection("Opcje Latania")

local FlyToggle = TabPoruszanie:CreateToggle({
   Name = "Latanie (Zastępuje też klawisz F)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
        Flying = Value
        toggleFly()
   end,
})

TabPoruszanie:CreateSlider({
   Name = "Prędkość latania",
   Range = {10, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
        Speed = Value
   end,
})

mouse.KeyDown:Connect(function(key)
    if key:lower() == "f" then
        Flying = not Flying
        FlyToggle:Set(Flying)
        toggleFly()
    end
end)

-- Zakładka 2: Gracze (Teleportacja)
local TabGracze = Window:CreateTab("Gracze", 4483362458)
local SectionGracze = TabGracze:CreateSection("Interakcje z graczami")

local PlayerDropdown = TabGracze:CreateDropdown({
   Name = "Wybierz cel",
   Options = pobierzGraczy(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "DropdownGraczy",
   Callback = function(Option)
        wybranyGracz = type(Option) == "table" and Option[1] or Option
   end,
})

TabGracze:CreateButton({
   Name = "🔄 Odśwież listę graczy",
   Callback = function()
        PlayerDropdown:Refresh(pobierzGraczy())
   end,
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

-- Zakładka 3: EXPLOIT (Czarne Niebo)
local TabExploit = Window:CreateTab("Exploit", 4483362458)
local SectionExploit = TabExploit:CreateSection("Modyfikacje Serwera")

TabExploit:CreateButton({
   Name = "🌌 Zmień niebo na CZARNE (7 sekund)",
   Callback = function()
        -- Zapisywanie oryginalnego stanu
        local stareTime = Lighting.TimeOfDay
        local starySky = Lighting:FindFirstChildOfClass("Sky")
        
        -- Zmiana na czarne
        Lighting.TimeOfDay = "00:00:00"
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0, 0, 0)
        
        if starySky then starySky.Parent = nil end
        
        local czarneNiebo = Instance.new("Sky")
        czarneNiebo.SkyboxBk = "rbxassetid://0"
        czarneNiebo.SkyboxDn = "rbxassetid://0"
        czarneNiebo.SkyboxFt = "rbxassetid://0"
        czarneNiebo.SkyboxLf = "rbxassetid://0"
        czarneNiebo.SkyboxRt = "rbxassetid://0"
        czarneNiebo.SkyboxUp = "rbxassetid://0"
        czarneNiebo.Parent = Lighting
        
        -- Exploit wysyłający sygnał do innych graczy przez luki w RemoteEvents
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") then
                local nazwa = v.Name:lower()
                if nazwa:match("light") or nazwa:match("sky") or nazwa:match("time") or nazwa:match("day") or nazwa:match("sync") then
                    pcall(function() v:FireServer("00:00:00") end)
                    pcall(function() v:FireServer(Color3.new(0,0,0)) end)
                    pcall(function() v:FireServer(0) end)
                end
            end
        end
        
        Rayfield:Notify({Title = "Exploit", Content = "Niebo zmienione na 7 sekund!", Duration = 2})
        
        -- Licznik 7 sekund i przywracanie
        task.delay(7, function()
            czarneNiebo:Destroy()
            if starySky then starySky.Parent = Lighting end
            Lighting.TimeOfDay = stareTime
            Lighting.GlobalShadows = true
            Lighting.Ambient = Color3.fromRGB(128, 128, 128)
            
            -- Wysłanie sygnału przywracającego do serwera
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local nazwa = v.Name:lower()
                    if nazwa:match("light") or nazwa:match("sky") or nazwa:match("time") or nazwa:match("day") or nazwa:match("sync") then
                        pcall(function() v:FireServer(stareTime) end)
                        pcall(function() v:FireServer(14) end)
                    end
                end
            end
            Rayfield:Notify({Title = "Exploit", Content = "Niebo wróciło do normy.", Duration = 2})
        end)
   end,
})

Rayfield:Notify({Title = "planexd_0 Hub", Content = "Wgrano z zakładką Exploit!", Duration = 5})
