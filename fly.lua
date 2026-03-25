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

-- Obsługa klawisza F do latania
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

-- Rozwijana lista graczy
local PlayerDropdown = TabGracze:CreateDropdown({
   Name = "Wybierz cel",
   Options = pobierzGraczy(),
   CurrentOption = {""},
   MultipleOptions = false,
   Flag = "DropdownGraczy",
   Callback = function(Option)
        -- Rayfield zwraca tabelę, wyciągamy z niej pierwszy element
        wybranyGracz = type(Option) == "table" and Option[1] or Option
   end,
})

-- Przycisk odświeżania listy (gdy ktoś dołączy do gry)
TabGracze:CreateButton({
   Name = "🔄 Odśwież listę graczy",
   Callback = function()
        PlayerDropdown:Refresh(pobierzGraczy())
   end,
})

-- Przycisk Teleportacji
TabGracze:CreateButton({
   Name = "⚡ Teleportuj do gracza",
   Callback = function()
        if wybranyGracz then
            local target = Players:FindFirstChild(wybranyGracz)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                -- Teleportujemy naszą postać do postaci celu
                player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2) -- Lądujemy minimalnie za jego plecami
                
                Rayfield:Notify({
                   Title = "Sukces",
                   Content = "Teleportowano do: " .. wybranyGracz,
                   Duration = 3,
                   Image = 4483362458,
                })
            else
                Rayfield:Notify({Title = "Błąd", Content = "Gracz nie żyje lub nie można go znaleźć.", Duration = 3})
            end
        else
            Rayfield:Notify({Title = "Uwaga", Content = "Najpierw wybierz gracza z listy!", Duration = 3})
        end
   end,
})

Rayfield:Notify({Title = "planexd_0 Script Hub", Content = "Wgrano najnowszą wersję z Teleportem!", Duration = 5})
